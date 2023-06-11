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
                .font(.system(size: 56))
                .foregroundColor(tint)
                .padding(.top, 10)
                .padding(.horizontal, 24)

            contentBuilder(item)
                .padding(.vertical, 16)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 24)
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
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(32)
    }

    func showPrevious() {
        isTransitionForward = false
        withAnimation {
            itemIndex -= 1
        }
    }

    func showNext() {
        isTransitionForward = true
        withAnimation {
            itemIndex += 1
        }
    }
}
