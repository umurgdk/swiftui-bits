//
//  MetalUIView.swift
//  MetalUI
//
//  Created by Umur Gedik on 23.06.2023.
//

import SwiftUI

struct MUIView<ID: Hashable>: ViewModifier {
    let id: ID
    let kind: String

    @Environment(\.muiContainer) var container

    func body(content: Content) -> some View {
        content.anchorPreference(
            key: MUIHierarchyPreferenceKey.self,
            value: .bounds,
            transform: { anchor in
                [
                    MUIHierarchyNode(
                        id: AnyHashable(id),
                        bounds: anchor,
                        parent: container!,
                        kind: .view
                    )
                ]
            }
        )
    }
}

public extension View {
    func metalUIView<ID: Hashable>(id: ID, kind: String) -> some View {
        modifier(MUIView(id: id, kind: kind))
    }
}

struct MUIHierarchyNode: Equatable, Identifiable {
    let id: AnyHashable
    let bounds: Anchor<CGRect>
    let parent: AnyHashable
    let kind: Kind

    enum Kind {
        case view
        case container
    }
}

struct MUIHierarchyPreferenceKey: PreferenceKey {
    typealias Value = [MUIHierarchyNode]
    static let defaultValue: Value = []
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}
