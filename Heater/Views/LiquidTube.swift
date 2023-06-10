//
//  LiquidTube.swift
//  SwiftUIBits
//
//  Created by Umur Gedik on 8.06.2023.
//

import SwiftUI

public struct LiquidTube: View {
    public let value: Double
    public let range: ClosedRange<Double>
    public let palette: Palette
    public let hasShadows: Bool

    public init(
        value: Double,
        range: ClosedRange<Double>,
        palette: Palette = Palette.default,
        hasShadows: Bool = true
    ) {
        self.value = value
        self.range = range
        self.palette = palette
        self.hasShadows = hasShadows
    }

    public struct Palette {
        let colors: [Color]

        public static let `default` = Palette(colors: [
            Color(red: 1, green: 53/255, blue: 0),
            Color(red: 1, green: 226/255, blue: 0),
            Color(red: 160/255, green: 230/255, blue: 100/255),
            Color(red: 101/255, green: 227/255, blue: 1)
        ])

        public static func custom(_ colors: [Color]) -> Self {
            Palette(colors: colors)
        }
    }

    var percentage: Double {
        let raw = (value - range.lowerBound) / range.upperBound
        return raw > 1 ? 1 : raw
    }

    public var body: some View {
        ZStack(alignment: .center) {
            Capsule().fill(Color.white)
            Capsule().fill(Color(white: 0.93)).padding(4)

            Liquid(percentage: percentage, palette: palette.colors)
                .padding(4)

            TubeHighlights()
        }
        .background(
            Liquid(percentage: percentage, palette: palette.colors)
                .scaleEffect(x: 0.9, y: 1)
                .offset(x: -25, y: -10)
                .blur(radius: 15)
                .opacity(0.5)
        )
        .frame(width: 70, height: 360)
    }
}

struct TubeHighlights: View {
    var body: some View {
        HStack(spacing: 0) {
            Capsule()
                .fill(Color.white)
                .frame(width: 8)
                .padding(.leading, 12)
                .padding(.vertical, 30)

            Spacer()

            Capsule()
                .fill(Color.white)
                .frame(width: 16)
                .padding(.trailing, 8)
                .padding(.vertical, 30)
        }
        .blur(radius: 5)
        .opacity(0.75)
        .drawingGroup()
    }
}

struct LiquidTube_Previews: PreviewProvider {
    static var previews: some View {
        LiquidTube(value: 30, range: 0...1000)
    }
}
