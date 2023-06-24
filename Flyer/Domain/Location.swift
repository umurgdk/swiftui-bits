//
//  Location.swift
//  Flyer
//
//  Created by Umur Gedik on 23.06.2023.
//

import Foundation

struct Location: Codable, Identifiable, Sendable {
    public let name: String
    public let country: String
    public let coordinate: LocationCoordinate
    public var transient: Bool

    public var id: LocationCoordinate { coordinate }
}
