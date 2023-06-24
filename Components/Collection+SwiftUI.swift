//
//  Collection+SwiftUI.swift
//  Components
//
//  Created by Umur Gedik on 23.06.2023.
//

import Foundation

public struct RandomAccessibleZip<A, B> where A: RandomAccessCollection, B: RandomAccessCollection, A.Index == B.Index, A.Index == Int {
    public let count: Int
    fileprivate let left: A
    fileprivate let right: B

    public init(_ left: A, _ right: B) {
        self.count = Swift.min(left.count, right.count)
        self.left = left
        self.right = right
    }
}

public func zipUI<A, B>(_ left: A, _ right: B) -> some RandomAccessCollection where A: RandomAccessCollection, B: RandomAccessCollection, A.Index == B.Index, A.Index == Int {
    RandomAccessibleZip(left, right)
}

extension RandomAccessibleZip: RandomAccessCollection {
    public typealias Index = Int
    public typealias Element = (A.Element, B.Element)

    public var startIndex: Index { 0 }
    public var endIndex: Index { count }

    public subscript(position: Index) -> Element {
        (left[position], right[position])
    }
}

public struct RandomAccessibleEnumerated<T> where T: RandomAccessCollection, T.Index == Int {
    public let count: Int
    private let storage: T

    init(storage: T) {
        self.count = storage.count
        self.storage = storage
    }
}

public extension RandomAccessCollection where Index == Int {
    func enumeratedUI() -> RandomAccessibleEnumerated<Self> {
        RandomAccessibleEnumerated(storage: self)
    }
}

extension RandomAccessibleEnumerated: RandomAccessCollection {
    public typealias Element = (offset: Int, element: T.Element)
    public typealias Index = Int

    public var startIndex: Int { storage.startIndex }
    public var endIndex: Int { storage.endIndex }

    public subscript(position: Int) -> Element {
        (offset: position, element: storage[position])
    }
}
