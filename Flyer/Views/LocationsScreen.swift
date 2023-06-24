//
//  LocationsScreen.swift
//  Flyer
//
//  Created by Umur Gedik on 23.06.2023.
//

import SwiftUI
import MetalUI

struct LocationsScreen: View {
    @EnvironmentObject var appState: AppState
    @State var isAddLocationSheetPresented = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                LocationList(
                    locations: appState.locations,
                    temperatures: appState.temperatures
                )

                if let error = appState.error {
                    ErrorView(error: error) {
                        appState.error = nil
                    }.transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.default, value: appState.error != nil)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        appState.error = nil
                        isAddLocationSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
            .sheet(isPresented: $isAddLocationSheetPresented) {
                AddLocationScreen().environmentObject(appState)
            }
        }
        .onAppear {
            Task {
                try? await appState.addUserLocationIfNeeded()
            }
        }
    }
}

struct LocationsScreen_Previews: PreviewProvider {
    static var previews: some View {
        LocationsScreen().environmentObject(AppState())
    }
}
