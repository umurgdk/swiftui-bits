//
//  FlyerApp.swift
//  Flyer
//
//  Created by Umur Gedik on 22.06.2023.
//

import SwiftUI

@MainActor
@main
struct FlyerApp: App {
    let state: AppState

    @State var isOnboarded: Bool


    init() {
        var state: AppState

        if let appStateJSON = UserDefaults.standard.string(forKey: "appState") {
            state = try! JSONDecoder().decode(AppState.self, from: appStateJSON.data(using: .utf8)!)
        } else {
            state = AppState()
        }

        _isOnboarded = State(initialValue: state.isOnboarded)

        state.onPersistRequired = { state in
            guard let json = try? JSONEncoder().encode(state) else { return }
            UserDefaults.standard.set(String(data: json, encoding: .utf8)!, forKey: "appState")
        }

        self.state = state
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if isOnboarded {
                    ContentView().environmentObject(state)
                } else {
                    OnboardingView().environmentObject(state)
                }
            }
        }
    }
}


struct OnboardingView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            Text("We can always show the weather information in your current location.")

            Spacer()

            Button("Enable Location Weather") {
                appState.requestLocationAccess()
                appState.isOnboarded = true
            }

            Button("Skip") {
                appState.isOnboarded = true
            }
        }.scenePadding()
    }
}
