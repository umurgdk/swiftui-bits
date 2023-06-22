//
//  DetailedPlane.swift
//  Vacuum
//
//  Created by Umur Gedik on 19.06.2023.
//

import Foundation
import Metal

struct DetailedPlane {
    let resolution: Int

    let vertexBuffer: MTLTypedBuffer<Vertex>
    let indexBuffer: MTLTypedBuffer<UInt32>

    let numberOfVertices: Int
    let numberOfIndices: Int
    let numberOfQuads: Int

    init(device: MTLDevice, resolution: Int) {
        self.resolution = resolution

        self.numberOfQuads = resolution * resolution
        self.numberOfVertices = (resolution + 1) * (resolution + 1)
        self.numberOfIndices = self.numberOfQuads * 6

        let step = 1.0 / Float(resolution)

        let verticesPerDimension = UInt32(resolution) + 1

        // NOTE(umur): Don't use stride, 32bit floating points are not relaible
        //             for this usecase, we need to make sure there are at least
        //             resolution + 1 vertices per row and resolution + 1 rows
        //             in total.
        var vertices: [Vertex] = []
        vertices.reserveCapacity(self.numberOfVertices)

        for row in 0..<verticesPerDimension {
            for col in 0..<verticesPerDimension {
                vertices.append(
                    Vertex(
                        position: SIMD3<Float>(
                            Float(col) * step,
                            Float(row) * step,
                            0
                        ),

                        tex_coord: SIMD2<Float>(
                            Float(col) / Float(verticesPerDimension - 1),
                            Float(row) / Float(verticesPerDimension - 1)
                        )
                    )
                )
            }
        }

        self.vertexBuffer = MTLTypedBuffer(device: device, with: vertices)

        var indices: [UInt32] = []
        indices.reserveCapacity(self.numberOfIndices)

        for row in 0..<UInt32(resolution) {
            let rowStartIndex = row * verticesPerDimension

            for col in 0..<UInt32(resolution) {
                let quadTopLeftIndex = rowStartIndex + col
                let quadTopRightIndex = quadTopLeftIndex + 1

                let quadBottomLeftIndex = quadTopLeftIndex + verticesPerDimension
                let quadBottomRightIndex = quadBottomLeftIndex + 1

                indices.append(quadTopLeftIndex)
                indices.append(quadBottomLeftIndex)
                indices.append(quadBottomRightIndex)
                indices.append(quadTopRightIndex)
                indices.append(quadTopLeftIndex)
                indices.append(quadBottomRightIndex)
            }
        }

        self.indexBuffer = MTLTypedBuffer(device: device, with: indices)
    }
}
