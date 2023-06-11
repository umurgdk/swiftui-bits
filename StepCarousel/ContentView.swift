//
//  ContentView.swift
//  StepCarousel
//
//  Created by Umur Gedik on 10.06.2023.
//

import SwiftUI

struct ContentView: View {
    @State var selectedReviewIndex = 0
    let tint = Color(red:0.94, green:0.94, blue:0.89)

    var body: some View {
        HStack(spacing: 32) {
            ReviewCarousel(
                items: reviews,
                itemIndex: $selectedReviewIndex,
                tint: tint
            ) {
                ReviewBody(review: $0, tint: tint)
            }
            .frame(width: 350)
            .zIndex(2)

            ProductCarousel(
                items: reviews.map(\.product),
                itemIndex: selectedReviewIndex
            ) { product, isPreview, width in
                ProductCard(
                    product: product,
                    tint: tint,
                    width: width
                ).redacted(reason: isPreview ? .placeholder : [])
            }
            .cornerRadius(32)
            .clipped()
        }
        .animation(.default, value: selectedReviewIndex)
        .padding(40)
        .frame(height: 500)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.9))
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ImageLoader())
    }
}
