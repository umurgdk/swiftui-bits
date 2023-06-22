//
//  AppState.swift
//  Flyer
//
//  Created by Umur Gedik on 22.06.2023.
//

import Foundation
import CoreLocation

enum WeatherAPIError: Error {
    case network(URLError?)
    case notFound(Location)
}

enum AppError: Error {
    case weatherAPIError(WeatherAPIError)
    case unexpected(underlying: Error)
}

@MainActor
final class AppState: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var isOnboarded: Bool {
        didSet {
            onPersistRequired?(self)
        }
    }

    @Published var temperatures: [Location.ID: Measurement<UnitTemperature>]
    @Published var error: AppError?

    var locationPermissionGranted: Bool? {
        didSet {
            onPersistRequired?(self)
        }
    }

    var onPersistRequired: (@MainActor (AppState) -> Void)? = nil

    @Published var locations: [Location] {
        didSet {
            onPersistRequired?(self)

            Task {
                do {
                    try await fetchTemperatures()
                } catch let error as WeatherAPIError {
                    self.error = AppError.weatherAPIError(error)
                } catch {
                    self.error = AppError.unexpected(underlying: error)
                }
            }
        }
    }


    private let urlSession: URLSession
    private let geocoder = CLGeocoder()

    private var temperatureRequests: Set<Location.ID> = []
    private let locationManager: CLLocationManager
    private var userLocation: CLLocationCoordinate2D?

    init(
        isOnboarded: Bool = false,
        locationPermissionGranted: Bool? = nil,
        locations: [Location] = [],
        temperatures: [Location.ID: Measurement<UnitTemperature>] = [:],
        urlSession: URLSession = .shared,
        locationManager: CLLocationManager = .init()
    ) {
        self.isOnboarded = isOnboarded
        self.locations = locations
        self.temperatures = temperatures
        self.urlSession = urlSession
        self.locationManager = locationManager

        super.init()

        locationManager.delegate = self
    }

    func resolveAddress(_ address: String) async throws -> [Location] {
        if geocoder.isGeocoding {
            geocoder.cancelGeocode()
        }

        let placemarks = try await geocoder.geocodeAddressString(address)
        return placemarks.compactMap { Location.init(from: $0, transient: true) }
    }

    func addLocation(_ location: Location, transient: Bool = false) {
        var location = location
        location.transient = transient
        locations.insert(location, at: 0)
    }

    func addUserLocationIfNeeded() async throws {
        locationManager.requestLocation()
    }

    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }

    private func addUserLocation(_ location: CLLocation) async throws {
        guard
            let placemark = try await geocoder.reverseGeocodeLocation(location).first,
            let location = Location(from: placemark, transient: true)
        else { return }

        addLocation(location, transient: true)
    }

    private func updateLocationManagerAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationPermissionGranted = true
        case .notDetermined:
            locationPermissionGranted = nil
        default:
            locationPermissionGranted = false
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let clLocation = locations.first else { return }
        Task { [weak self, clLocation] in
            try? await self?.addUserLocation(clLocation)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { await self.updateLocationManagerAuthorizationStatus() }
    }

    func fetchTemperatures() async throws {
        let locations = self.locations.filter {
            !temperatureRequests.contains($0.id)
        }

        defer { temperatureRequests.subtract(locations.map(\.id)) }

        let results = try await withThrowingTaskGroup(of: (Location, Double).self) { group in
            for location in locations {
                _ = group.addTaskUnlessCancelled {
                    let temperature = try await self.fetchTemperature(for: location)
                    return (location, temperature)
                }
            }


            var results: [(Location, Double)] = []
            for try await result in group {
                results.append(result)
            }

            return results
        }

        for (location, temperature) in results {
            temperatures[location.id] = .init(value: temperature, unit: .celsius)
        }
    }

    func fetchTemperature(for location: Location) async throws -> Double {
        struct WeatherAPIResponse: Decodable {
            let currentWeather: CurrentWeather

            struct CurrentWeather: Decodable {
                let temperature: Double
            }
        }

        var urlComponents = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        urlComponents.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude))
        ]

        do {
            let (data, response) = try await urlSession.data(from: urlComponents.url!)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherAPIError.network(nil)
            }

            if httpResponse.statusCode == 404 {
                throw WeatherAPIError.notFound(location)
            } else if httpResponse.statusCode != 200 {
                throw WeatherAPIError.network(nil)
            }

            let weatherResponse = try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
            return weatherResponse.currentWeather.temperature
        } catch let error as URLError {
            throw WeatherAPIError.network(error)
        } catch {
            throw error
        }

    }
}

struct Location: Codable, Identifiable, Sendable {
    public let name: String
    public let country: String
    public let coordinate: LocationCoordinate
    fileprivate var transient: Bool

    public var id: LocationCoordinate { coordinate }
}

fileprivate extension Location {
    init?(from placemark: CLPlacemark, transient: Bool) {
        guard
            let name = placemark.name,
            let country = placemark.country,
            let location = placemark.location
        else {
            return nil
        }

        self.name = name
        self.country = country
        self.coordinate = LocationCoordinate(from: location.coordinate)
        self.transient = transient
    }
}

struct LocationCoordinate: Codable, Hashable, Sendable {
    let latitude: Double
    let longitude: Double

    fileprivate var coreLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

fileprivate extension LocationCoordinate {
    init(from location: CLLocationCoordinate2D) {
        self.latitude = location.latitude
        self.longitude = location.longitude
    }
}

// MARK: - Codable Implementation -

extension AppState: Codable {
    enum CodingKeys: CodingKey {
        case isOnboarded
        case locations
        case locationPermissionGranted
    }

    func encode(to encoder: Encoder) throws {
        let nonTransientLocations = locations.filter { !$0.transient }

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isOnboarded, forKey: .isOnboarded)
        try container.encode(nonTransientLocations, forKey: .locations)
        try container.encode(locationPermissionGranted, forKey: .locationPermissionGranted)
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            isOnboarded: try container.decode(Bool.self, forKey: .isOnboarded),
            locationPermissionGranted: try container.decodeIfPresent(Bool.self, forKey: .locationPermissionGranted),
            locations: try container.decode([Location].self, forKey: .locations)
        )
    }
}
