//
//  ReviewBody.swift
//  StepCarousel
//
//  Created by Umur Gedik on 11.06.2023.
//

import SwiftUI
import Components

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
                RemoteImage(url: review.author.avatar)
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    .compositingGroup()

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
