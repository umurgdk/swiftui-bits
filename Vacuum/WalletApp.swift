//
//  WalletApp.swift
//  Wallet
//
//  Created by Umur Gedik on 14.06.2023.
//

import SwiftUI
import Components

@main
@MainActor
struct WalletApp: App {
    let imageLoader = ImageLoader()
    @State var time: Float = 0.5

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(imageLoader)
        }
    }
}
