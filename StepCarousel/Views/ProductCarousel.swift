//
//  ProductCarousel.swift
//  StepCarousel
//
//  Created by Umur Gedik on 11.06.2023.
//

import SwiftUI

struct ProductCarousel<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let itemIndex: Int
    @ViewBuilder let contentBuilder: (Item, Bool, Double) -> Content

    var showPrevious: Bool { itemIndex == items.count - 1 && items.count > 1 }
    var showNext: Bool { itemIndex < items.count - 1 }

    var previousItem: Item { items[itemIndex - 1] }
    var nextItem: Item { items[itemIndex + 1] }
    var item: Item { items[itemIndex] }

    @Namespace var animation

    var itemIndices: [Int] {
        let startIndex = itemIndex - (showPrevious ? 1 : 0)
        let endIndex = itemIndex + (showNext ? 1 : 0)
        return Array(startIndex...endIndex)
    }

    let previewWidth: Double = 60
    let itemGap: Double = 16

    var body: some View {
        GeometryReader { geom in
            HStack(spacing: itemGap) {
                ForEach(itemIndices, id: \.self) { index in
                    let item = items[index]
                    let width = itemWidth(for: item, in: geom.size)

                    contentBuilder(item, isPreview(item), width)
                        .id(item.id)
                        .transition(
                            .productCarouselItem(
                                isPreview: isPreview(item),
                                itemGap: itemGap,
                                itemWidth: width
                            )
                        )
                }
            }
        }
    }

    func isPrevious(_ item: Item) -> Bool {
        showPrevious && item.id == previousItem.id
    }

    func isNext(_ item: Item) -> Bool {
        showNext && item.id == nextItem.id
    }

    func isPreview(_ item: Item) -> Bool {
        isPrevious(item) || isNext(item)
    }

    func itemWidth(for item: Item, in size: CGSize) -> Double {
        if isPreview(item) {
            return previewWidth
        }

        return size.width - previewWidth - itemGap
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

private struct ProductCarouselTransition: ViewModifier {
    let isActive: Bool
    let movement: Movement
    let itemGap: Double
    let itemWidth: Double

    enum Movement {
        case insertFromRight
        case insertFromLeft
        case removeToLeft
        case removeToRight

        var alignment: Alignment {
            switch self {
            case .insertFromRight, .removeToRight: return .trailing
            case .insertFromLeft, .removeToLeft: return .leading
            }
        }

        func offset(itemWidth: Double) -> Double {
            switch self {
            case .insertFromRight, .removeToRight: return 60
            case .insertFromLeft, .removeToLeft: return -60
            }
        }
    }

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: isActive ? 60 : itemWidth)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .offset(x: isActive ? -60 : 0, y: 0)
//            .offset(x: isActive ? movement.offset(itemWidth: itemWidth) : 0, y: 0)
    }
}
