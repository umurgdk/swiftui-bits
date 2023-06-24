//  Created by Umur Gedik on 24.06.2023.

import Foundation
import Metal

struct MUIVertex: Equatable {
    let position: SIMD3<Float>
    let normal: SIMD3<Float>

    static let descriptor: MTLVertexDescriptor = {
        var offset: UInt = 0

        let d = MTLVertexDescriptor()

        d.attributes[0].format = .float3
        d.attributes[1].format = .float3
        d.attributes[1].offset = MemoryLayout<MUIVertex>.offset(of: \.normal) ?? 0
        d.layouts[0].stride = MemoryLayout<MUIVertex>.stride

        return d
    }()
}
