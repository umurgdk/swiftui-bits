//
//  View+RenderImage.swift
//  Components
//
//  Created by Umur Gedik on 14.06.2023.
//

import SwiftUI

public extension View {
    func renderUIImage(size: CGSize) -> PlatformImage {
        #if os(iOS)
        let hostingController = PlatformHostingController(rootView: self.edgesIgnoringSafeArea(.all))
        let uiView = hostingController.unwrappedView
        uiView.bounds = CGRect(origin: .zero, size: size)

        let renderer = UIGraphicsImageRenderer(size: uiView.bounds.size)
        let image = renderer.image { _ in
            hostingController.view.drawHierarchy(
                in: uiView.bounds,
                afterScreenUpdates: true
            )
        }
        #else
        let uiView = NSHostingView(rootView: self.edgesIgnoringSafeArea(.all))
        uiView.frame = CGRect(origin: .zero, size: size)
        let rect = CGRect(origin: .zero, size: size)
        let imageRep = uiView.bitmapImageRepForCachingDisplay(in: rect)!
        imageRep.size = rect.size
        uiView.cacheDisplay(in: rect, to: imageRep)
        let image = NSImage(size: rect.size)
        image.addRepresentation(imageRep)
        #endif

        print("Rendered image size:", image.size)

        return image
    }
}
