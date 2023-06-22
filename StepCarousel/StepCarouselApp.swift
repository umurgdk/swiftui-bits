//
//  StepCarouselApp.swift
//  StepCarousel
//
//  Created by Umur Gedik on 10.06.2023.
//

import SwiftUI
import Components

@main
@MainActor
struct StepCarouselApp: App {
    let imageLoader = ImageLoader()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(imageLoader)
                .onAppear {
                    imageLoader.prefetch(urls: reviews.map(\.product.image))
                    imageLoader.prefetch(urls: reviews.map(\.author.avatar))
                }
        }
    }
}
