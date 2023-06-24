//
//  MetalUIRenderProvider.swift
//  MetalUI
//
//  Created by Umur Gedik on 23.06.2023.
//

import SwiftUI

public struct MUIRenderProvider<Content: View>: View {
    let explicitViewMeshes: [String: any MUIViewMesh]
    let edgesIgnoringSafeArea: Edge.Set
    let innerContent: () -> Content

    @State var containerID = UUID()
    @State var renderedNodeIDs: Set<AnyHashable> = []

    public init(
        explicitViewMeshes: [String : any MUIViewMesh] = [:],
        edgesIgnoringSafeArea: Edge.Set = [],
        @ViewBuilder innerContent: @escaping () -> Content
    ) {
        self.explicitViewMeshes = explicitViewMeshes
        self.edgesIgnoringSafeArea = edgesIgnoringSafeArea
        self.innerContent = innerContent
    }

    
    public var body: some View {
        innerContent()
            .environment(\.muiContainer, containerID)
            .overlayPreferenceValue(MUIHierarchyPreferenceKey.self, alignment: .topLeading) { preferences in
                GeometryReader { geom in
                    MUIRenderView(
                        geometry: geom,
                        explicitViewMeshes: explicitViewMeshes,
                        hierarchy: preferences,
                        renderedNodeIDs: renderedNodeIDs
                    )
                }.edgesIgnoringSafeArea(edgesIgnoringSafeArea)
            }
    }
}
