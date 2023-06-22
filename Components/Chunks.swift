//
//  Chunks.swift
//  Components
//
//  Created by Umur Gedik on 14.06.2023.
//

import Foundation

public struct Chunks<C> where C: RandomAccessCollection, C.SubSequence: RandomAccessCollection {
    fileprivate let size: Int
    fileprivate let collection: C
    fileprivate let numberOfChunks: Int

    fileprivate init(collection: C, size: Int) {
        self.size = size
        self.collection = collection
        self.numberOfChunks = Int(ceil(Double(collection.count) / Double(size)))
    }
}

public extension RandomAccessCollection {
    func chunked(by size: Int) -> Chunks<Self> {
        Chunks(collection: self, size: size)
    }
}

extension Chunks: RandomAccessCollection {
    public typealias Index = Int
    public typealias Element = C.SubSequence

    public var startIndex: Index { 0 }
    public var endIndex: Index { numberOfChunks - 1 }

    public subscript(position: Index) -> Element {
        let underlyingStartIndex = collection.index(collection.startIndex, offsetBy: position * size)
        let underlyingEndIndex = collection.index(underlyingStartIndex, offsetBy: size)

        let startIndex = Swift.min(underlyingStartIndex, collection.endIndex)
        let endIndex = Swift.min(underlyingEndIndex, collection.endIndex)
        
        return collection[startIndex..<endIndex]
    }
}
