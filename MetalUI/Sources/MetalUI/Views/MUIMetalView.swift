//
//  MUIMetalView.swift
//  MetalUI
//
//  Created by Umur Gedik on 23.06.2023.
//

import SwiftUI
import MetalKit

struct MUIMetalView: UIViewRepresentable {
    let hierarchy: [MUIHierarchyNode]

    func makeCoordinator() -> MUIRenderer {
        MUIRenderer(device: MTLCreateSystemDefaultDevice()!)
    }

    func makeUIView(context: Context) -> MTKView {
        let view = MTKView(frame: .zero, device: context.coordinator.device)
        view.delegate = context.coordinator
        view.clearColor = MTLClearColorMake(0, 0, 0, 0)
        view.colorPixelFormat = .bgra8Unorm
        view.framebufferOnly = true
        view.backgroundColor = .clear
        view.isPaused = false
        view.isUserInteractionEnabled = false
        view.autoResizeDrawable = true
        return view
    }

    func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.setHierarchy(hierarchy)
    }
}
