//
//  MetalUIContainer.swift
//  MetalUI
//
//  Created by Umur Gedik on 23.06.2023.
//

import SwiftUI

struct MUIContainer: ViewModifier {
    @Environment(\.muiContainer) var container
    @State var id = UUID()

    func body(content: Content) -> some View {
        content
            .environment(\.muiContainer, id)
            .transformAnchorPreference(
                key: MUIHierarchyPreferenceKey.self,
                value: .bounds,
                transform: { preference, anchor in
                    preference.append(
                        MUIHierarchyNode(
                            id: id,
                            bounds: anchor,
                            parent: container!,
                            kind: .container
                        )
                    )
                }
            )
    }
}

public extension View {
    func metalUIContainer() -> some View {
        modifier(MUIContainer())
    }
}

struct MUIContainerEnvironmentKey: EnvironmentKey {
    typealias Value = AnyHashable?
    static let defaultValue: Value = nil
}

extension EnvironmentValues {
    var muiContainer: AnyHashable? {
        get { self[MUIContainerEnvironmentKey.self] }
        set { self[MUIContainerEnvironmentKey.self] = newValue }
    }
}
