//
//  CoreGraphics+Metal.swift
//  MetalUI
//
//  Created by Umur Gedik on 23.06.2023.
//

import MetalKit
import QuartzCore

extension CGRect {
    var float4: SIMD4<Float> {
        SIMD4(Float(origin.x), Float(origin.y), Float(size.width), Float(size.height))
    }
}

extension CGPoint {
    var float2: SIMD2<Float> {
        SIMD2(Float(x), Float(y))
    }
}

extension CGSize {
    var float2: SIMD2<Float> {
        SIMD2(Float(width), Float(height))
    }
}

extension CATransform3D {
    var float4x4: simd_float4x4 {
        simd_float4x4(rows: [
            SIMD4<Float>(Float(m11), Float(m12), Float(m13), Float(m14)),
            SIMD4<Float>(Float(m21), Float(m22), Float(m23), Float(m24)),
            SIMD4<Float>(Float(m31), Float(m32), Float(m33), Float(m34)),
            SIMD4<Float>(Float(m41), Float(m42), Float(m43), Float(m44)),
        ])
    }
}
