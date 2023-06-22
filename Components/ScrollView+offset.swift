//
//  ScrollView+offset.swift
//  Components
//
//  Created by Umur Gedik on 14.06.2023.
//

import SwiftUI

public extension View {
    func onOffsetChange(
        in coordinateSpace: CoordinateSpace,
        onUpdate: @escaping (CGPoint) -> Void
    ) -> some View {
        self.modifier(
            OffsetReader(
                coordinateSpace: coordinateSpace,
                onUpdate: onUpdate
            )
        )
    }
}

struct OffsetReader: ViewModifier {
    let coordinateSpace: CoordinateSpace
    let onUpdate: (CGPoint) -> Void

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geom in
                let offset = geom.frame(in: coordinateSpace).origin
                Color.clear.preference(key: OffsetPreferenceKey.self, value: offset)
            }
        ).onPreferenceChange(OffsetPreferenceKey.self, perform: onUpdate)
    }
}

struct OffsetPreferenceKey: PreferenceKey {
    typealias Value = CGPoint

    static var defaultValue: CGPoint = .zero

    static func reduce(
        value: inout CGPoint,
        nextValue: () -> CGPoint
    ) {
        value = nextValue()
    }
}
