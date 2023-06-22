//
//  View+SizePreference.swift
//  Components
//
//  Created by Umur Gedik on 15.06.2023.
//

import SwiftUI

struct OverlaySizePreferenceModifier<ID: Hashable>: ViewModifier {
    let id: ID
    func body(content: Content) -> some View {
        content.overlay(
            GeometryReader { geom in
                Color.clear.preference(
                    key: SizePreferenceKey.self,
                    value: [id: geom.size]
                )
            }
        )
    }
}

public extension View {
    func sizePreference<ID: Hashable>(id: ID) -> some View {
        modifier(OverlaySizePreferenceModifier(id: id))
    }

    func onSizeChange<ID: Hashable>(id: ID, perform: @escaping (CGSize) -> Void) -> some View {
        self.onPreferenceChange(SizePreferenceKey.self) { values in
            perform(values[id] ?? .zero)
        }
    }
}

struct SizePreferenceKey<Namespace: Hashable>: PreferenceKey {
    typealias Value = [Namespace: CGSize]
    static var defaultValue: Value { [:] }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
