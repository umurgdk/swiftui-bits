//
//  VacuumRenderer.swift
//  Vacuum
//
//  Created by Umur Gedik on 17.06.2023.
//

import SwiftUI
import MetalKit
import Components

class VacuumRenderer: NSObject, MTKViewDelegate {
    let scene: VacuumSceneView
    let device: MTLDevice
    let cmdQueue: MTLCommandQueue
    let renderPipelineState: MTLRenderPipelineState

    var texture: MTLTexture?
    let textureSampler: MTLSamplerState

    let duration: TimeInterval
    let createdAt: Date

    var uniforms = Uniforms()
    let uniformsBuffer: MTLTypedBuffer<Uniforms>
    var instanceBuffer: MTLTypedBuffer<VacuumItem>

    let planeModel: DetailedPlane
    var firstRenderAt = Date.distantPast

    let scale: Double

    init(
        scene: VacuumSceneView,
        image: PlatformImage,
        frames: [CGRect],
        sourceFrames: [CGRect],
        duration: TimeInterval,
        insets: EdgeInsets,
        scale: Double
    ) {
        self.scene = scene
        self.device = MTLCreateSystemDefaultDevice()!
        self.cmdQueue = self.device.makeCommandQueue()!

        self.duration = duration

        let library = device.makeDefaultLibrary()!
        let vertexFunc = library.makeFunction(name: "vertex_main")!
        let fragmentFunc = library.makeFunction(name: "frag_main")!

        let vertexDesc = MTLVertexDescriptor()
        vertexDesc.layouts[0].stride = MemoryLayout<Vertex>.stride
        vertexDesc.attributes[0].format = .float3
        vertexDesc.attributes[1].format = .float2
        vertexDesc.attributes[1].offset = MemoryLayout<Vertex>.offset(of: \.tex_coord)!

        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.label = "VacuumRenderPipeline"
        renderPipelineDescriptor.fragmentFunction = fragmentFunc
        renderPipelineDescriptor.vertexFunction = vertexFunc
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexDescriptor = vertexDesc

        self.renderPipelineState = try! device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)

        self.uniformsBuffer = MTLTypedBuffer(of: Uniforms.self, device: device, count: 1, options: .storageModeShared)

        let textureSamplerDescriptor = MTLSamplerDescriptor()
        textureSamplerDescriptor.normalizedCoordinates = true
        textureSamplerDescriptor.minFilter = .linear
        textureSamplerDescriptor.magFilter = .linear
        textureSamplerDescriptor.mipFilter = .linear

        self.textureSampler = device.makeSamplerState(descriptor: textureSamplerDescriptor)!

        self.planeModel = DetailedPlane(device: device, resolution: 10)

        let items = frames.enumerated().map { (i, frame) in
            VacuumItem(
                origin: .init(
                    Float(frame.minX * scale).rounded(),
                    Float(frame.minY * scale).rounded()
                ),
                size: .init(
                    Float(frame.width * scale).rounded(),
                    Float(frame.height * scale).rounded()
                ),
                tex_src_origin: .init(
                    Float((sourceFrames[i].minX * scale).rounded()) / Float(image.size.width * scale),
                    Float((sourceFrames[i].minY * scale).rounded()) / Float(image.size.height * scale)
                ),
                tex_src_size: .init(
                    Float((sourceFrames[i].width * scale).rounded()) / Float(image.size.width * scale),
                    Float((sourceFrames[i].height * scale).rounded()) / Float(image.size.height * scale)
                )
            )
        }

        self.instanceBuffer = MTLTypedBuffer(device: device, with: items)

        createdAt = Date()
        self.scale = scale
        uniforms.viewport_scale = Float(scale)

        super.init()

        texture = image.makeMetalTexture(device: device, scale: scale)
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        uniforms.viewport_size = .init(Float(view.frame.width * scale), Float(view.frame.height * scale))
        uniforms.vacuum_position = .init(
            Float(view.frame.midX * scale),
            Float(view.frame.minY * scale + 25 * scale)
        )
    }

    func draw(in view: MTKView) {
        guard
            let cmdBuffer = cmdQueue.makeCommandBuffer(),
            let renderPassDescriptor = view.currentRenderPassDescriptor
        else { return }

        guard let encoder = cmdBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        else { return }

        if firstRenderAt == .distantPast {
            firstRenderAt = Date()
            uniforms.time = 0
        } else {
            uniforms.time = Float(Date().timeIntervalSince(firstRenderAt) / duration)
        }

        encoder.setRenderPipelineState(renderPipelineState)

        encoder.setViewport(
            MTLViewport(
                originX: 0, originY: 0,
                width: view.frame.width * scale,
                height: view.frame.height * scale,
                znear: -1, zfar: 1
            )
        )

        encoder.setFragmentTexture(texture, index: 0)
        encoder.setFragmentSamplerState(textureSampler, index: 0)

        encoder.setVertexBuffers([
            planeModel.vertexBuffer.mtlBuffer,
            instanceBuffer.mtlBuffer,
        ], offsets: [0, 0, 0], range: 0..<2)

        encoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.size, index: 2)

        encoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: planeModel.numberOfIndices,
            indexType: .uint32,
            indexBuffer: planeModel.indexBuffer.mtlBuffer,
            indexBufferOffset: 0,
            instanceCount: instanceBuffer.count)

        encoder.endEncoding()
        cmdBuffer.present(view.currentDrawable!)
        cmdBuffer.commit()
    }
}
