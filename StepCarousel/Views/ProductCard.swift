//
//  ProductCard.swift
//  StepCarousel
//
//  Created by Umur Gedik on 11.06.2023.
//

import SwiftUI
import Components

struct ProductCard: View {
    let product: Product
    let tint: Color

    @Environment(\.productCarouselReveal) var reveal
    @Environment(\.horizontalSizeClass) var horizontalSize

    static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "MMM yyyy",
            options: 0,
            locale: .current
        )
        return f
    }()

    var date: String {
        Self.formatter.string(from: product.date)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            tint.overlay(RemoteImage(url: product.image))

            LinearGradient(
                colors: [Color.black.opacity(0), Color.black.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .opacity(reveal)

            VStack(alignment: .leading) {
                Text(date)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .fixedSize()
                Text(product.name)
                    .font(.largeTitle)
                    .fixedSize()
            }
            .shadow(radius: 2, x: 0, y: 2)
            .compositingGroup()
            .blur(radius: (1 - reveal) * 10)
            .opacity(reveal)
            .padding(horizontalSize == .regular ? 32 : 16)
        }
        .compositingGroup()
        .environment(\.colorScheme, .dark)
    }
}
