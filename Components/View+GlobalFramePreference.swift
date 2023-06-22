//
//  View+GlobalFramePreference.swift
//  Components
//
//  Created by Umur Gedik on 20.06.2023.
//

import SwiftUI

public extension View {
    func onFrameChange(in coordinateSpace: CoordinateSpace, perform: @escaping (ViewFrame) -> Void) -> some View {
        modifier(FrameChangeListener(coordinateSpace: coordinateSpace, perform: perform))
    }
}

public struct ViewFrame: Equatable {
    public let frame: CGRect
    public let safeAreaInsets: EdgeInsets
}

struct FrameChangeListener: ViewModifier {
    let coordinateSpace: CoordinateSpace
    let perform: (ViewFrame) -> Void

    func body(content: Content) -> some View {
        content.overlay(
            GeometryReader { geom in
                Color.clear.preference(
                    key: FramePreferenceKey.self,
                    value: ViewFrame(
                        frame: geom.frame(in: coordinateSpace),
                        safeAreaInsets: geom.safeAreaInsets
                    )
                )
            }
        ).onPreferenceChange(FramePreferenceKey.self, perform: perform)
    }
}

struct FramePreferenceKey: PreferenceKey {
    typealias Value = ViewFrame

    static var defaultValue: Value = ViewFrame(frame: .zero, safeAreaInsets: EdgeInsets())

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
