//
//  AsyncMap.swift
//  Components
//
//  Created by Umur Gedik on 23.06.2023.
//

import Foundation

public extension Collection where Element: Sendable {
    func asyncMap<T>(_ block: @escaping (Element) async throws -> T) async rethrows -> [T] where T: Sendable {
        try await withThrowingTaskGroup(of: T.self) { group in
            for element in self {
                _ = group.addTaskUnlessCancelled {
                    try await block(element)
                }
            }

            var results: [T] = []
            results.reserveCapacity(self.count)
            for try await result in group {
                results.append(result)
            }

            return results
        }
    }
}
