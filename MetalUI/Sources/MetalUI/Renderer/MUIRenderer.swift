//
//  MUIRenderer.swift
//  MetalUI
//
//  Created by Umur Gedik on 23.06.2023.
//

import Foundation
import MetalKit

final class MUIRenderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let cmdQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState

    let resourceManager: MUIResourceManager
    var hierarchy: [MUIHierarchyNode] = []

    init(device: MTLDevice) {
        self.device = device
        self.cmdQueue = device.makeCommandQueue()!
        self.resourceManager = MUIResourceManager(device: device)

        let library = try! device.makeDefaultLibrary(bundle: Bundle.module)

        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_main")!
        renderPipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragment_main")!
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        renderPipelineDescriptor.vertexDescriptor = MUIVertex.descriptor

        self.pipelineState = try! device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
    }

    func setHierarchy(_ hierarchy: [MUIHierarchyNode]) {
        self.hierarchy = hierarchy
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }

    func draw(in view: MTKView) {
        guard
            let renderPassDescriptor = view.currentRenderPassDescriptor,
            let cmdBuffer = cmdQueue.makeCommandBuffer(),
            let cmdEncoder = cmdBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor),
            let currentDrawable = view.currentDrawable
        else {
            return
        }

        var vertices: [MTLPackedFloat3] = [
            MTLPackedFloat3Make(0, 1, 0),
            MTLPackedFloat3Make(-1, -1, 0),
            MTLPackedFloat3Make(1, -1, 0),
        ]

        cmdEncoder.setRenderPipelineState(pipelineState)
        cmdEncoder.setVertexBytes(&vertices, length: MemoryLayout<MTLPackedFloat3>.size * 3, index: 0)
        cmdEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        cmdEncoder.endEncoding()

        cmdBuffer.present(currentDrawable)
        cmdBuffer.commit()
    }
}
