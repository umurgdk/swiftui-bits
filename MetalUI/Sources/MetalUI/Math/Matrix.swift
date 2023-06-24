//
//  Matrix.swift
//  MetalUI
//
//  Created by Umur Gedik on 23.06.2023.
//

import MetalKit

enum Matrix {
    static func model(from frame: CGRect) -> simd_float4x4 {
        let scale = CATransform3DMakeScale(frame.size.width, frame.size.height, 1.0)
        return CATransform3DTranslate(scale, frame.origin.x, frame.origin.y, 0.0).float4x4
    }
}
