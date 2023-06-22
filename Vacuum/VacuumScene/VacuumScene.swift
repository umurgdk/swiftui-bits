//
//  ClothScene.swift
//  Vacuum
//
//  Created by Umur Gedik on 15.06.2023.
//

import SwiftUI
import MetalKit
import Components

struct VacuumSceneView: PlatformViewRepresentable {
    @Environment(\.displayScale) var scale

    let image: PlatformImage
    let frames: [CGRect]
    let sourceFrames: [CGRect]
    let duration: TimeInterval
    let insets: EdgeInsets

    func makeCoordinator() -> VacuumRenderer {
        VacuumRenderer(
            scene: self,
            image: image,
            frames: frames,
            sourceFrames: sourceFrames,
            duration: duration,
            insets: insets,
            scale: scale
        )
    }

    func makePlatformView(context: Context) -> MTKView {
        let view = MTKView()
        #if os(macOS)
        view.layer?.isOpaque = false
        #else
        view.isOpaque = false
        #endif
        view.delegate = context.coordinator
        view.device = context.coordinator.device
        view.clearColor = MTLClearColorMake(0, 0, 0, 0)
        return view
    }

    func updatePlatformView(_ platformView: MTKView, context: Context) {
    }
}

