//
//  Formatters.swift
//  Flyer
//
//  Created by Umur Gedik on 23.06.2023.
//

import Foundation

private let temperatureFormatter = MeasurementFormatter()
func formatTemperature(_ temperature: Measurement<UnitTemperature>?) -> String {
    if let temperature {
        return temperatureFormatter.string(from: temperature)
    } else {
        return "–"
    }
}
