//
//  ContentView.swift
//  StepCarousel
//
//  Created by Umur Gedik on 10.06.2023.
//

import SwiftUI

struct Review: Identifiable {
    let id = UUID()
    let body: String
    let author: Author
    let product: Product
}

struct Author: Identifiable {
    let id = UUID()
    let name: String
    let avatar: URL
}

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let image: URL
}

let reviews = [
    Review(
        body: "I absolutely love this product! It has exceeded my expectations in every way. Highly recommended!",
        author: Author(
            name: "John Doe",
            avatar: URL(string: "https://i.pravatar.cc/300?img=0")!
        ),
        product: Product(
            name: "Last Trip",
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 3))!,
            image: URL(string: "https://picsum.photos/id/1/800/600")!
        )
    ),

    Review(
        body: "I've been using this service for a while now, and I'm extremely satisfied. The customer support is top-notch, and results are fantastic!",
        author: Author(
            name: "Sarah M",
            avatar: URL(string: "https://i.pravatar.cc/300?img=1")!
        ),
        product: Product(
            name: "Last Trip",
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 3))!,
            image: URL(string: "https://picsum.photos/id/100/800/600")!
        )
    ),

    Review(
        body: "I've been using this service for a while now, and I'm extremely satisfied. The customer support is top-notch, and results are fantastic!",
        author: Author(
            name: "Sarah M",
            avatar: URL(string: "https://i.pravatar.cc/300?img=1")!
        ),
        product: Product(
            name: "Last Trip",
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 3))!,
            image: URL(string: "https://picsum.photos/id/120/800/600")!
        )
    )
]

struct ContentView: View {
    @State var selectedReviewIndex = 0
    let tint = Color(red:0.94, green:0.94, blue:0.89)

    var body: some View {
        HStack {
            StepContentCard(items: reviews, itemIndex: $selectedReviewIndex, tint: tint) {
                review in
                ReviewBody(review: review, tint: tint)
            }.frame(width: 350)

            Carousel(items: reviews.map(\.product), itemIndex: selectedReviewIndex) {
                product, isPreview in
                ProductCard(product: product, tint: tint)
                    .redacted(reason: isPreview ? .placeholder : [])
            }
        }
        .padding(40)
        .frame(height: 500)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.9))
        .ignoresSafeArea()
    }
}

struct ProductCard: View {
    let product: Product
    let tint: Color

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

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            tint.layoutPriority(2)
            AsyncImage(url: product.image) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                tint.overlay(ProgressView().opacity(0.5))
            }.unredacted()

            VStack(alignment: .leading) {
                Text(date).font(.headline).foregroundColor(.secondary)
                Text(product.name).font(.largeTitle)
            }
            .fixedSize()
            .padding(32)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [Color.black.opacity(0), Color.black.opacity(0.5)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .opacity(redaction.contains(.placeholder) ? 0 : 1)
        }
        .environment(\.colorScheme, .dark)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}

struct Carousel<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let itemIndex: Int
    @ViewBuilder let contentBuilder: (Item, Bool) -> Content

    var showPrevious: Bool { itemIndex == items.count - 1 && items.count > 1 }
    var showNext: Bool { itemIndex < items.count - 1 }

    var previousItem: Item { items[itemIndex - 1] }
    var nextItem: Item { items[itemIndex + 1] }
    var item: Item { items[itemIndex] }

    @Namespace var animation

    var body: some View {
        HStack(spacing: 16) {
            if showPrevious {
                contentBuilder(previousItem, true)
                    .matchedGeometryEffect(id: previousItem.id, in: animation)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .frame(width: 64)
            }

            contentBuilder(item, false)
                .matchedGeometryEffect(id: item.id, in: animation)
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .frame(maxWidth: .infinity)

            if showNext {
                contentBuilder(nextItem, true)
                    .matchedGeometryEffect(id: nextItem.id, in: animation)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .frame(width: 64)
            }
        }
        .animation(.easeOut, value: itemIndex)
    }
}

struct ReviewBody: View {
    let review: Review
    let tint: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text(review.body)
                .font(.body)
                .multilineTextAlignment(.leading)
                .layoutPriority(1)
            HStack {
                AsyncImage(url: review.author.avatar) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle().fill(tint).overlay(ProgressView().opacity(0.5))
                }
                .clipShape(Circle())
                .frame(width: 32, height: 32)

                Text(review.author.name)
                    .overlay(
                        tint.brightness(-0.5)
                            .hueRotation(.degrees(-20))
                            .mask(Text(review.author.name)),

                        alignment: .leading
                    ).font(.subheadline)
            }
        }
    }
}

struct StepContentCard<Item, Content: View>: View {
    let items: [Item]
    @Binding var itemIndex: Int

    var tint: Color
    @ViewBuilder let contentBuilder: (Item) -> Content


    var hasNextContent: Bool { itemIndex < items.count - 1 }
    var hasPreviousContent: Bool { itemIndex > 0 }

    var item: Item { items[itemIndex] }

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "quote.opening")
                .font(.system(size: 56))
                .foregroundColor(tint)
                .padding(.top, 10)

            contentBuilder(item)
                .padding(.vertical, 16)
                .frame(maxHeight: .infinity, alignment: .top)

            HStack(spacing: 12) {
                Button { itemIndex -= 1 } label: {
                    StepButtonLabel.previous(tint: tint)
                }.disabled(!hasPreviousContent)

                Button { itemIndex += 1 } label: {
                    StepButtonLabel.next(tint: tint)
                }.disabled(!hasNextContent)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(32)
    }
}

struct StepButtonLabel: View {
    let image: Image
    let tint: Color

    @Environment(\.isEnabled) var isEnabled

    static func previous(tint: Color) -> Self {
        StepButtonLabel(image: Image(systemName: "chevron.left"), tint: tint)
    }

    static func next(tint: Color) -> Self {
        StepButtonLabel(image: Image(systemName: "chevron.right"), tint: tint)
    }

    var body: some View {
        ZStack {
            Circle().fill(tint)
            image.fontWeight(.bold).foregroundColor(.primary.opacity(isEnabled ? 0.6 : 0.2))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
