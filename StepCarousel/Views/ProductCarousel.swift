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
    let contentBuilder: (Item) -> Content

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

    let previewWidth: Double = 60
    let itemGap: Double = 16

    var body: some View {
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
                            itemGap: itemGap,
                            itemWidth: width
                        )
                    )
                    .transaction { trans in
                        trans.isContinuous = true
                    }
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

