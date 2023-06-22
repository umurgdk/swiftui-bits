//
//  AlbumScreen.swift
//  Vacuum
//
//  Created by Umur Gedik on 22.06.2023.
//

import SwiftUI

struct AlbumScreen: View {
    let pictures: [URL]
    let onVisibleFramesChange: ([CGRect]) -> Void
    let onDeleteAll: () -> Void

    var body: some View {
        Group {
            if pictures.isEmpty {
                VStack(spacing: 24) {
                    Image(systemName: "sparkles")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)

                    Text("No More\nDumb Pictures")
                        .multilineTextAlignment(.center)
                        .font(.title)
                }
                .foregroundColor(.secondary)
                .transition(.move(edge: .top).combined(with: .opacity))
            } else {
                AlbumGrid(pictures: pictures, onVisibleFramesChange: onVisibleFramesChange)
            }
        }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Dumb Pictures")
                        Text("Sparks Joy?").font(.caption).foregroundColor(.secondary)
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    if !pictures.isEmpty {
                        Button {
                            onDeleteAll()
                        } label: {
                            Image(systemName: "sparkles")
                        }
                    }
                }
            }
    }
}
