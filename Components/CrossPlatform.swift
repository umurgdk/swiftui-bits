//
//  CrossPlatform.swift
//  Components
//
//  Created by Umur Gedik on 21.06.2023.
//

import SwiftUI

#if os(iOS)
public typealias PlatformImage = UIImage
public typealias PlatformView = UIView
public typealias PlatformHostingController = UIHostingController

public extension Image {
    init(platformImage: PlatformImage) {
        self.init(uiImage: platformImage)
    }
}

public extension UIViewController {
    var unwrappedView: PlatformView {
        self.view!
    }
}

public protocol PlatformViewRepresentable: UIViewRepresentable {
    associatedtype PlatformViewType: PlatformView
    func makePlatformView(context: Context) -> PlatformViewType
    func updatePlatformView(_ platformView: PlatformViewType, context: Context)
}

extension PlatformViewRepresentable {
    public func makeUIView(context: Context) -> PlatformViewType {
        makePlatformView(context: context)
    }

    public func updateUIView(_ uiView: PlatformViewType, context: Context) {
        updatePlatformView(uiView, context: context)
    }
}

#else
public typealias PlatformImage = NSImage
public typealias PlatformView = NSView
public typealias PlatformHostingController = NSHostingController

public protocol PlatformViewRepresentable: NSViewRepresentable {
    associatedtype PlatformViewType: PlatformView
    func makePlatformView(context: Context) -> PlatformViewType
    func updatePlatformView(_ platformView: PlatformViewType, context: Context)
}

extension PlatformViewRepresentable {
    public func makeNSView(context: Context) -> PlatformViewType {
        makePlatformView(context: context)
    }

    public func updateNSView(_ nsView: PlatformViewType, context: Context) {
        updatePlatformView(nsView, context: context)
    }
}

public extension NSImage {
    var cgImage: CGImage? {
        var rect = CGRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
}

public extension Image {
    init(platformImage: PlatformImage) {
        self.init(nsImage: platformImage)
    }
}

public extension NSViewController {
    var unwrappedView: PlatformView {
        self.view
    }
}
#endif
