//
//  LocationRow.swift
//  Flyer
//
//  Created by Umur Gedik on 23.06.2023.
//

import SwiftUI

struct LocationRow: View {
    let location: Location
    let temperature: Measurement<UnitTemperature>?

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(location.name)

                    if location.transient {
                        Image(systemName: "location")
                    }
                }.font(.title2)

                Text(location.country).foregroundColor(.secondary)
            }

            Spacer()

            Text(formatTemperature(temperature))
                .foregroundColor(temperature == nil ? .secondary : .primary)
                .font(.title)
        }
        .colorScheme(.dark)
        .padding()
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.primary)
    }
}

struct LocationRow_Previews: PreviewProvider {
    @ViewBuilder
    static var previews: some View {
        ForEach(PreviewData.locations) { location in
            LocationRow(
                location: location,
                temperature: PreviewData.temperatures[location.id]
            )
        }
        .previewLayout(.sizeThatFits)
    }
}
