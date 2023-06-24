//
//  RectangleMesh.swift
//  MetalUI
//
//  Created by Umur Gedik on 23.06.2023.
//

import Foundation

public struct RectangleMesh: Equatable, MUIViewMesh {
    let vertices: [MUIVertex]
    let indices: [UInt32]

    static let quad = rectangle(resolution: 1)

    init(resolution: Int) {
        let numberOfVertices = (resolution + 1) * (resolution + 1)
        let numberOfQuads = resolution * resolution
        let numberOfVerticesPerQuad = 6
        let numberOfIndices = numberOfQuads * numberOfVerticesPerQuad

        var vertices: [MUIVertex] = []
        vertices.reserveCapacity(numberOfVertices)

        var indices: [UInt32] = []
        indices.reserveCapacity(numberOfIndices)

        let vertexNormal = SIMD3<Float>(0, 0, 1)
        let stepDistance: Float = 1.0 / Float(resolution)

        for row in 0..<(resolution + 1) {
            let y = Float(row) * stepDistance

            for col in 0..<(resolution + 1) {
                let x = Float(col) * stepDistance

                vertices.append(
                    MUIVertex(
                        position: SIMD3<Float>(x, y, 0),
                        normal: vertexNormal
                    )
                )
            }
        }

        for row in 0..<resolution {
            for col in 0..<resolution {
                let topLeftVertIndex = UInt32(row * resolution) + UInt32(col)
                let topRightVertIndex = topLeftVertIndex + 1

                let bottomLeftVertIndex = topLeftVertIndex + UInt32(resolution) + 1
                let bottomRightVertIndex = bottomLeftVertIndex + 1

                indices.append(topLeftVertIndex)
                indices.append(bottomLeftVertIndex)
                indices.append(bottomRightVertIndex)

                indices.append(topLeftVertIndex)
                indices.append(bottomRightVertIndex)
                indices.append(topRightVertIndex)
            }
        }

        self.vertices = vertices
        self.indices = indices
    }
}

public extension MUIViewMesh where Self == RectangleMesh {
    static func rectangle(resolution: Int = 1) -> Self {
        RectangleMesh(resolution: resolution)
    }
}
