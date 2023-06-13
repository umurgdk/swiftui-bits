//
//  ProductCarouselTransition.swift
//  StepCarousel
//
//  Created by Umur Gedik on 13.06.2023.
//

import SwiftUI

struct ProductCarouselRevealKey: EnvironmentKey {
    static var defaultValue: Double = 0
}

public extension EnvironmentValues {
    var productCarouselReveal: Double {
        get { self[ProductCarouselRevealKey.self] }
        set { self[ProductCarouselRevealKey.self] = newValue }
    }
}

private struct ProductCarouselRevealTransition: ViewModifier {
    var reveal: Double

    func body(content: Content) -> some View {
        content.environment(\.productCarouselReveal, reveal)
    }
}

private struct ProductCarouselSizeTransition: ViewModifier {
    let isActive: Bool
    let itemWidth: Double
    let itemGap: Double
    let previewWidth: Double

    var isPreview: Bool {
        itemWidth == previewWidth
    }

    var offsetX : Double {
        let offset = previewWidth + itemGap
        return isPreview ? offset : -offset
    }

    func body(content: Content) -> some View {
        content
            .frame(width: isActive ? previewWidth : itemWidth)
            .cornerRadius(24)
            .clipped()
            .frame(maxWidth: itemWidth, alignment: isPreview ? .center : .leading)
            .offset(x: isActive ? offsetX : 0, y: 0)
    }
}

internal extension AnyTransition {
    static func productCarouselItem(
        isPreview: Bool,
        itemWidth: Double,
        previewWidth: Double,
        itemGap: Double
    ) -> AnyTransition {
        .modifier(
            active: ProductCarouselRevealTransition(reveal: 0),
            identity: ProductCarouselRevealTransition(reveal: isPreview ? 0 : 1)
        ).combined(
            with: .modifier(
                active: ProductCarouselSizeTransition(
                    isActive: true,
                    itemWidth: itemWidth,
                    itemGap: itemGap,
                    previewWidth: previewWidth
                ),
                identity: ProductCarouselSizeTransition(
                    isActive: false,
                    itemWidth: itemWidth,
                    itemGap: itemGap,
                    previewWidth: previewWidth
                )
            )
        ).combined(with: .opacity)
    }
}

