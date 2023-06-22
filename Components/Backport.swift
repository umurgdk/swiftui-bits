//
//  Backport.swift
//  Components
//
//  Created by Umur Gedik on 22.06.2023.
//

import Foundation
import SwiftUI

public enum Backport {
    public struct ProgressView: PlatformViewRepresentable {
        #if os(macOS)
        public typealias PlatformViewType = NSProgressIndicator
        #else
        public typealias PlatformViewType = UIProgressView
        #endif

        public func makePlatformView(context: Context) -> PlatformViewType {
            #if os(macOS)
            let view = NSProgressIndicator()
            view.startAnimating()
            #else
            let view = UIProgressView(progressViewStyle: .default)
            #endif

            return view
        }

        public func updatePlatformView(_ platformView: PlatformViewType, context: Context) {

        }
    }
}
