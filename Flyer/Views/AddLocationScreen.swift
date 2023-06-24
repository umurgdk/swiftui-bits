//
//  AddLocationScreen.swift
//  Flyer
//
//  Created by Umur Gedik on 23.06.2023.
//

import SwiftUI

struct AddLocationScreen: View {
    @EnvironmentObject private var appState: AppState
    @State private var locations: [Location] = []
    @State private var searchQuery: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search for a place...", text: $searchQuery)
                        .textFieldStyle(.roundedBorder)
                    Spacer()
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }.padding()
                List(locations) { location in
                    VStack(alignment: .leading) {
                        Text(location.name).bold()
                        Text(location.country)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        appState.addLocation(location)
                        presentationMode.wrappedValue.dismiss()
                    }
                }

                if let error = appState.error {
                    ErrorView(error: error) {
                        appState.error = nil
                    }.transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.default, value: appState.error != nil)
            .onChange(of: searchQuery) { newValue in
                Task {
                    let locations = try? await appState.resolveAddress(newValue)
                    self.locations = locations ?? []
                }
            }
        }
    }
}

struct AddLocationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationScreen().environmentObject(AppState())
    }
}
