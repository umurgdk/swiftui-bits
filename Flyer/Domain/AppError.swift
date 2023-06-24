//
//  AppError.swift
//  Flyer
//
//  Created by Umur Gedik on 23.06.2023.
//

import Foundation

enum WeatherAPIError: Error {
    case network(URLError?)
    case notFound(Location)
}

enum AppError: Error {
    case weatherAPIError(WeatherAPIError)
    case unexpected(underlying: Error?)
}
