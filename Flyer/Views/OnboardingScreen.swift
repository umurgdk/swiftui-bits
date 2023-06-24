//
//  OnboardingScreen.swift
//  Flyer
//
//  Created by Umur Gedik on 23.06.2023.
//

import SwiftUI

struct OnboardingScreen: View {
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
        }.padding()
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen().environmentObject(AppState())
    }
}
