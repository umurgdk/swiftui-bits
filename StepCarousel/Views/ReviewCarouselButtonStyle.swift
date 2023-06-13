//
//  ReviewCarouselButtonStyle.swift
//  StepCarousel
//
//  Created by Umur Gedik on 11.06.2023.
//

import SwiftUI

struct ReviewCarouselButtonStyle: ButtonStyle {
    let image: Image
    let tint: Color

    @Environment(\.isEnabled) var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle().fill(tint)
            image
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary.opacity(isEnabled ? 0.6 : 0.2))
        }
        .compositingGroup()
        .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

extension ButtonStyle where Self == ReviewCarouselButtonStyle {
    static func previous(tint: Color) -> Self {
        ReviewCarouselButtonStyle(image: Image(systemName: "chevron.left"), tint: tint)
    }

    static func next(tint: Color) -> Self {
        ReviewCarouselButtonStyle(image: Image(systemName: "chevron.right"), tint: tint)
    }
}
