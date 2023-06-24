//
//  MUIViewMesh.swift
//  MetalUI
//
//  Created by Umur Gedik on 23.06.2023.
//

import Foundation

public protocol MUIViewMesh: Equatable {
    var name: String { get }
}

public extension MUIViewMesh {
    var name: String {
        String(describing: Self.self)
    }
}
