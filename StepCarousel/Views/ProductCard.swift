//
//  ProductCard.swift
//  StepCarousel
//
//  Created by Umur Gedik on 11.06.2023.
//

import SwiftUI

struct ProductCard: View {
    let product: Product
    let tint: Color
    let width: Double

    @Environment(\.redactionReasons) var redaction

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

    var isRedacted: Bool { redaction.contains(.placeholder) }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            tint.overlay(
                RemoteImage(url: product.image).unredacted()
            )

            LinearGradient(
                colors: [Color.black.opacity(0), Color.black.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 130)
            .opacity(isRedacted ? 0 : 1)

            VStack(alignment: .leading) {
                Text(date)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .unredacted()
                    .fixedSize()
                Text(product.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .unredacted()
                    .fixedSize()
            }
            .blur(radius: isRedacted ? 10 : 0)
            .opacity(isRedacted ? 0 : 1)
            .padding(32)
        }
        .frame(minWidth: 60)
        .cornerRadius(32)
        .clipped()
        .frame(width: width, alignment: .trailing)
        .environment(\.colorScheme, .dark)
    }
}

struct ImageSizingDemo: View {
    @EnvironmentObject var imageLoader: ImageLoader
    @State var width: Double = 300

    var body: some View {
        GeometryReader { geom in
            HStack {
                ForEach(reviews) { review in
                    Item(product: review.product, width: width)
                        .onTapGesture { width = width == 300 ? 50 : 300 }
                }
            }
            .animation(.default, value: width)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .onAppear { imageLoader.prefetch(urls: reviews.map(\.product.image))}
    }

    struct Item: View {
        let product: Product
        let width: Double
        var body: some View {
            RemoteImage(url: product.image)
                .frame(width: 300, height: 300)
                .background(Color(white: 0.97))
                .overlay(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0),
                            Color.black.opacity(0.5)
                        ],
                        startPoint: .top,
                        endPoint: .bottom)
                    .frame(height: 100),
                    alignment: .bottomLeading
                )
                .cornerRadius(64)
                .clipped()
                .frame(width: width, alignment: .leading)
                .clipped()
                .overlay(
                    Text(product.name)
                        .fixedSize()
                        .font(.system(size: 40, weight: .heavy))
                        .environment(\.colorScheme, .dark),
                    alignment: .bottomLeading
                )
        }
    }
}
