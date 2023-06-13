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

struct ProductCarouselTransition: ViewModifier {
    let isActive: Bool
    let movement: Movement
    let itemGap: Double
    let itemWidth: Double

    var reveal: Double { (isActive || movement.isPreview) ? 0 : 1 }

    enum Movement {
        case insertFromRight
        case insertFromLeft
        case removeToLeft
        case removeToRight

        var isPreview: Bool {
            self == .insertFromRight || self == .removeToRight
        }

        var alignment: Alignment {
            switch self {
            case .insertFromRight, .removeToRight: return .trailing
            case .insertFromLeft, .removeToLeft: return .leading
            }
        }

        func offset(itemGap: Double) -> Double {
            switch self {
            case .insertFromRight, .removeToRight: return 60 + itemGap
            case .insertFromLeft, .removeToLeft: return -60 - itemGap
            }
        }
    }

    func body(content: Content) -> some View {
        content
            .environment(\.productCarouselReveal, reveal)
            .frame(width: isActive ? 60 : itemWidth)
            .cornerRadius(32)
            .clipped()
            .frame(maxWidth: itemWidth, alignment: movement.alignment)
            .offset(x: isActive ? movement.offset(itemGap: itemGap) : 0, y: 0)
    }
}

internal extension AnyTransition {
    static func productCarouselItem(isPreview: Bool, itemGap: Double, itemWidth: Double) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: ProductCarouselTransition(
                    isActive: true,
                    movement: isPreview ? .insertFromRight : .insertFromLeft,
                    itemGap: itemGap,
                    itemWidth: itemWidth
                ),
                identity: ProductCarouselTransition(
                    isActive: false,
                    movement: isPreview ? .insertFromRight : .insertFromLeft,
                    itemGap: itemGap,
                    itemWidth: itemWidth
                )
            ),
            removal: .modifier(
                active: ProductCarouselTransition(
                    isActive: true,
                    movement: isPreview ? .removeToRight : .removeToLeft,
                    itemGap: itemGap,
                    itemWidth: itemWidth
                ),
                identity: ProductCarouselTransition(
                    isActive: false,
                    movement: isPreview ? .removeToRight : .removeToLeft,
                    itemGap: itemGap,
                    itemWidth: itemWidth
                )
            )
        )
    }
}

