//
//  ProductCarousel.swift
//  StepCarousel
//
//  Created by Umur Gedik on 11.06.2023.
//

import SwiftUI

public struct ProductCarousel<Item: Identifiable, ItemView: View>: View {
    public let items: [Item]
    public let itemIndex: Int
    public let contentBuilder: (Item) -> ItemView

    public let previewWidth: Double
    public let itemGap: Double

    public init(
        items: [Item],
        itemIndex: Int,
        @ViewBuilder contentBuilder: @escaping (Item) -> ItemView,
        previewItemWidth: Double = 60,
        itemGap: Double = 16
    ) {
        self.items = items
        self.itemIndex = itemIndex
        self.contentBuilder = contentBuilder
        self.previewWidth = previewItemWidth
        self.itemGap = itemGap
    }

    var showPrevious: Bool { itemIndex == items.count - 1 && items.count > 1 }
    var showNext: Bool { itemIndex < items.count - 1 }

    var previousItem: Item { items[itemIndex - 1] }
    var nextItem: Item { items[itemIndex + 1] }
    var item: Item { items[itemIndex] }

    var itemIndices: [Int] {
        let startIndex = itemIndex - (showPrevious ? 1 : 0)
        let endIndex = itemIndex + (showNext ? 1 : 0)
        return Array(startIndex...endIndex)
    }


    public var body: some View {
        GeometryReader { geom in
            HStack(spacing: itemGap) {
                ForEach(itemIndices, id: \.self) { index in
                    let item = items[index]
                    let width = itemWidth(for: item, in: geom.size)

                    ZStack {
                        contentBuilder(item)
                    }
                    .id(item.id)
                    .transition(
                        .productCarouselItem(
                            isPreview: isPreview(item),
                            itemWidth: width,
                            previewWidth: previewWidth,
                            itemGap: itemGap
                        )
                    )
                }
            }
        }
    }

    func isPreview(_ item: Item) -> Bool {
        item.id != self.item.id
    }

    func itemWidth(for item: Item, in size: CGSize) -> Double {
        if isPreview(item) {
            return previewWidth
        }

        return size.width - previewWidth - itemGap
    }
}

