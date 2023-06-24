//
//  LocationLis.swift
//  Flyer
//
//  Created by Umur Gedik on 23.06.2023.
//

import SwiftUI
import MetalUI

struct LocationList: View {
    let locations: [Location]
    let temperatures: [Location.ID: Measurement<UnitTemperature>]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(locations) { location in
                    LocationRow(
                        location: location,
                        temperature: temperatures[location.id]
                    ).metalUIView(id: location.id, kind: "LocationRow")
                }
            }
            .padding(.horizontal, 16)
        }
        .metalUIContainer()
    }
}

struct LocationList_Previews: PreviewProvider {
    static var previews: some View {
        LocationList(
            locations: PreviewData.locations,
            temperatures: PreviewData.temperatures
        )
    }
}
