//
//  Liquid.swift
//  Heater
//
//  Created by Umur Gedik on 10.06.2023.
//

import SwiftUI

struct Liquid: View {
    let percentage: Double
    let palette: [Color]

    var body: some View {
        GeometryReader { geom in
            ZStack {
                gradient
                    .overlay(Color(white: 0.95).blendMode(.plusDarker))
                    .mask(behindMask(in: geom.size))
                    .opacity(0.95)

                gradient
                    .mask(liquidMask(in: geom.size))
            }
            .clipShape(Capsule())
            .animation(.easeOut(duration: 0.4), value: percentage)
        }.drawingGroup()
    }

    var gradient: some View {
        LinearGradient(
            colors: palette,
            startPoint: .top,
            endPoint: .bottom
        )
    }

    func behindMask(in size: CGSize) -> some View {
        Wave(
            value: percentage,
            direction: .backward,
            phase: Double.pi / 2
        )
        .frame(height: size.height * (1 - percentage), alignment: .bottom)
        .frame(maxHeight: .infinity, alignment: .top)
    }

    func liquidMask(in size: CGSize) -> some View {
        ZStack {
            Wave(value: percentage)
                .frame(height: size.height * (1 - percentage), alignment: .bottom)
                .frame(maxHeight: .infinity, alignment: .top)

            Rectangle()
                .frame(height: size.height * percentage)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}


struct Liquid_Previews: PreviewProvider {
    static var previews: some View {
        Liquid(percentage: 0.5, palette: [Color.white, Color.red, Color.black])
    }
}
