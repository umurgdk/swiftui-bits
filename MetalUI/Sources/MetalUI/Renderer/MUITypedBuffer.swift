//
//  MTLBuffer+unsafeMutableBuffer.swift
//  MetalUI
//
//  Created by Umur Gedik on 20.06.2023.
//

import Metal

class MUITypedBuffer<T> {
    let mtlBuffer: MTLBuffer
    let count: Int

    init<T>(device: MTLDevice, with data: [T]) {
        self.count = data.count

        #if os(iOS)
        let storageMode: MTLResourceOptions = .storageModeShared
        #else
        let storageMode: MTLResourceOptions = .storageModeManaged
        #endif


        var mtlBuffer: MTLBuffer!
        data.withUnsafeBytes { ptr in
            mtlBuffer = device.makeBuffer(
                bytes: ptr.baseAddress!,
                length: MemoryLayout<T>.size * data.count,
                options: storageMode
            )
        }

        self.mtlBuffer = mtlBuffer
    }

    init(of type: T.Type = T.self, device: MTLDevice, count: Int, options: MTLResourceOptions) {
        self.mtlBuffer = device.makeBuffer(length: MemoryLayout<T>.size, options: options)!
        self.count = count
    }

    func withContents(block: (UnsafeMutableBufferPointer<T>) -> Void) {
        let rawPointer = mtlBuffer.contents().assumingMemoryBound(to: T.self)
        let bufferPointer = UnsafeMutableBufferPointer(start: rawPointer, count: count)
        block(bufferPointer)
    }

    func write(_ value: T) {
        withContents { $0[0] = value }
    }

    func write(contentsOf values: [T]) {
        withContents { buffer in
            buffer.initialize(fromContentsOf: values)
        }
    }
}
