//
//  ReviewCarousel.swift
//  StepCarousel
//
//  Created by Umur Gedik on 11.06.2023.
//

import SwiftUI

struct ReviewCarousel<Item: Identifiable, Content: View>: View {
    let items: [Item]
    @Binding var itemIndex: Int

    var tint: Color
    @ViewBuilder let contentBuilder: (Item) -> Content


    @State var isTransitionForward = true
    var hasNextContent: Bool { itemIndex < items.count - 1 }
    var hasPreviousContent: Bool { itemIndex > 0 }

    var item: Item { items[itemIndex] }

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "quote.opening")
                .font(.system(size: 40))
                .foregroundColor(tint)
                .padding(.horizontal, 16)

            contentBuilder(item)
                .padding(16)
                .frame(maxHeight: .infinity, alignment: .top)
                .compositingGroup()
                .id(item.id)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: isTransitionForward ? .trailing : .leading),
                        removal: .move(edge: isTransitionForward ? .leading : .trailing)
                    )
                    .combined(with: .opacity)
                )

            HStack(spacing: 12) {
                Button("Previous", action: showPrevious)
                    .buttonStyle(.previous(tint: tint))
                    .disabled(!hasPreviousContent)

                Button("Next", action: showNext)
                    .buttonStyle(.next(tint: tint))
                    .disabled(!hasNextContent)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(24)
    }

    func showPrevious() {
        isTransitionForward = false
        itemIndex -= 1
    }

    func showNext() {
        isTransitionForward = true
        itemIndex += 1
    }
}
