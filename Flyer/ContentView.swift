//
//  ContentView.swift
//  Flyer
//
//  Created by Umur Gedik on 22.06.2023.
//

import SwiftUI

struct WeatherInfo: Hashable, Identifiable {
    let city: String
    let temperature: Double

    var id: String { city }
}

let data = [
    WeatherInfo(city: "İzmir", temperature: 32.0),
    WeatherInfo(city: "Ghent", temperature: 19.0),
    WeatherInfo(city: "Amsterdam", temperature: 23.0),
    WeatherInfo(city: "Amsterdam", temperature: 23.0),
]

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct CardList: View {
    var body: some View {
        List {

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
