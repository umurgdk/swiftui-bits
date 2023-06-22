//
//  VacuumLayout.swift
//  Vacuum
//
//  Created by Umur Gedik on 22.06.2023.
//

import SwiftUI
import Components

class VacuumLayout: ObservableObject {
    var image = PlatformImage()
    var scrollOffset: CGPoint = .zero
    var visibleImageFrames: [CGRect] = []

    var screenFrame = CGRect.zero
    var screenInsets = EdgeInsets()

    var imageSize: CGSize {
        var size = CGSize(
            width: screenFrame.size.width,
            height: screenFrame.size.height + 8
        )

        let imageFramesMaxY = visibleImageFrames.map(\.maxY).max(by: <) ?? 0
        if imageFramesMaxY > size.height {
            size.height = imageFramesMaxY
        }

        return size
    }

    var frames: [CGRect] {
        visibleImageFrames.map { frame in
            var newFrame = frame
            newFrame.origin.x += screenFrame.minX
            newFrame.origin.y += screenFrame.minY
            return newFrame
        }
    }

    var sourceFrames: [CGRect] { visibleImageFrames }

    func setScrollOffset(_ offset: CGPoint) {
        self.scrollOffset = offset
    }

    func setVisibleImageFrames(_ frames: [CGRect]) {
        self.visibleImageFrames = frames
    }

    func setViewFrame(_ viewFrame: ViewFrame) {
        self.screenFrame = viewFrame.frame
        self.screenInsets = viewFrame.safeAreaInsets
        print(viewFrame)
    }
}
