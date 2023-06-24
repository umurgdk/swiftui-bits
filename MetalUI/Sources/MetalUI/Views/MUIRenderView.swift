//
//  MUIRenderView.swift
//  MetalUI
//
//  Created by Umur Gedik on 23.06.2023.
//

import SwiftUI

struct MUIRenderView: View {
    let geometry: GeometryProxy
    let explicitViewMeshes: [String: any MUIViewMesh]
    let hierarchy: [MUIHierarchyNode]
    let renderedNodeIDs: Set<AnyHashable>

    @ViewBuilder
    var body: some View {
        ZStack(alignment: .topLeading) {
            MUIMetalView(hierarchy: hierarchy)
                .layoutPriority(2)

            ForEach(hierarchy) { node in
                if node.kind == .view {
                    let frame = geometry[node.bounds]

                    Color.red
                        .frame(width: frame.width, height: frame.height)
                        .overlay(Text(String(describing: frame.origin)))
                        .offset(x: frame.minX, y: frame.minY)
                        .opacity(0.5)
                }
            }
        }.allowsHitTesting(false)
    }
}
