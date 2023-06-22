//
//  AlbumGrid.swift
//  Vacuum
//
//  Created by Umur Gedik on 22.06.2023.
//

import SwiftUI
import Components

struct AlbumGrid: View {
    let pictures: [URL]
    let onVisibleFramesChange: ([CGRect]) -> Void
    @Namespace var scrollCoordinateSpace

    var body: some View {
        GeometryReader { outerGeom in
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(pictures.chunked(by: 5), id: \.self) { triplet in
                        HStack(spacing: 4) {
                            ForEach(triplet, id: \.self) { pictureURL in
                                RemoteImage(url: pictureURL)
                                    .aspectRatio(1, contentMode: .fill)
                                    .background(
                                        GeometryReader { geom in
                                            let outerFrame = CGRect(origin: .zero, size: outerGeom.size)
                                            let itemFrame = geom.frame(in: .named(scrollCoordinateSpace))
                                            let isVisible = itemFrame.intersects(outerFrame)

                                            Color.clear.preference(
                                                key: VisibleFramesPreferenceKey.self,
                                                value: isVisible ? [itemFrame] : []
                                            )
                                        }
                                    )
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .coordinateSpace(name: scrollCoordinateSpace)
        .onPreferenceChange(
            VisibleFramesPreferenceKey.self,
            perform: onVisibleFramesChange
        )
    }
}

struct VisibleFramesPreferenceKey: PreferenceKey {
    typealias Value = [CGRect]

    static var defaultValue: Value = []

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}
