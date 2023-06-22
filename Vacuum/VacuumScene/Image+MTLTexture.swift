//
//  UIImage+MTLTexture.swift
//  Components
//
//  Created by Umur Gedik on 20.06.2023.
//

import MetalKit
import Components

public extension PlatformImage {
    func makeMetalTexture(device: MTLDevice, scale: Double) -> MTLTexture {
        let pixelWidth = Int(ceil(size.width * scale))
        let pixelHeight = Int(ceil(size.height * scale))

        let context = CGContext(
            data: nil,
            width: pixelWidth,
            height: pixelHeight,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        context.draw(cgImage!, in: CGRect(origin: .zero, size: CGSize(width: pixelWidth, height: pixelHeight)))

        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .rgba8Unorm,
            width: pixelWidth,
            height: pixelHeight,
            mipmapped: false
        )
        
        textureDescriptor.storageMode = .shared

        let newTexture = device.makeTexture(descriptor: textureDescriptor)!
        newTexture.replace(
            region: MTLRegionMake2D(0, 0, pixelWidth, pixelHeight),
            mipmapLevel: 0,
            withBytes: context.data!,
            bytesPerRow: context.bytesPerRow)

        return newTexture
    }
}
