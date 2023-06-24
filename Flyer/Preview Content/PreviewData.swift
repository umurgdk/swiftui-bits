//
//  PreviewData.swift
//  Flyer
//
//  Created by Umur Gedik on 23.06.2023.
//

import Foundation

enum PreviewData {
    static let locations = [
        Location(
            name: "Karsiyaka",
            country: "Turkiye",
            coordinate: LocationCoordinate(
                latitude: 38.45602180479968,
                longitude: 27.101465044178287
            ),
            transient: true
        ),
        Location(
            name: "Amsterdam",
            country: "Netherlands",
            coordinate: LocationCoordinate(
                latitude: 52.3674558441721,
                longitude: 4.911731324182672
            ),
            transient: false
        ),
        Location(
            name: "Ghent",
            country: "Belgium",
            coordinate: LocationCoordinate(
                latitude: 51.050442514593215,
                longitude: 3.7296574292854023
            ),
            transient: false
        ),
    ]
    
    static let temperatures: [Location.ID: Measurement<UnitTemperature>] = [
        // Karsiyaka
        LocationCoordinate(
            latitude: 38.45602180479968,
            longitude: 27.101465044178287
        ): .init(value: 24.0, unit: .celsius),

        // Amsterdam
        LocationCoordinate(
            latitude: 52.3674558441721,
            longitude: 4.911731324182672
        ): .init(value: 24.0, unit: .celsius)
    ]
}
