//
//  ContentView.swift
//  StepCarousel
//
//  Created by Umur Gedik on 10.06.2023.
//

import SwiftUI
import Components

struct ContentView: View {
    @State var selectedReviewIndex = 0
    let tint = Color(red:0.94, green:0.94, blue:0.89)

    @Environment(\.horizontalSizeClass) var horizontalSize

    var body: some View {
        HStack(spacing: 24) {
            ReviewCarousel(
                items: reviews,
                itemIndex: $selectedReviewIndex.animation(.easeOut(duration: 0.7)),
                tint: tint
            ) {
                ReviewBody(review: $0, tint: tint)
            }
            .frame(width: horizontalSize == .regular ? 350 : 250)
            .zIndex(2)

            ProductCarousel(
                items: reviews.map(\.product),
                itemIndex: selectedReviewIndex
            ) { product in
                ProductCard(
                    product: product,
                    tint: tint
                )
            }
            .cornerRadius(24)
            .clipped()
        }
        .padding(24)
        .frame(maxHeight: 500)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color(white: 0.9).ignoresSafeArea())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ImageLoader())
    }
}
