//
//  ContentView.swift
//  Wallet
//
//  Created by Umur Gedik on 14.06.2023.
//

import SwiftUI
import Components

let invalidPictureIDs = [422, 438, 414, 462, 463, 470, 489]
let allPictures: [URL] = (400...500).compactMap { i in
    guard !invalidPictureIDs.contains(i) else { return nil }
    return URL(string: "https://picsum.photos/id/\(i)/200/200")!
}

struct ContentView: View {
    @State var vacuuming = false
    @State var showMetalView = false
    @State var pictures = allPictures

    @StateObject
    var vacuumLayout = VacuumLayout()

    @EnvironmentObject
    var imageLoader: ImageLoader

    let vacuumDuration: TimeInterval = 2

    var body: some View {
        NavigationView {
            AlbumScreen(
                pictures: pictures,
                onVisibleFramesChange: vacuumLayout.setVisibleImageFrames(_:),
                onDeleteAll: { Task { await deleteAll() } }
            )
            .opacity(vacuuming ? 0 : 1)
            .animation(.linear(duration: 0.001).delay(0.001), value: vacuuming)
            .onFrameChange(in: .global, perform: vacuumLayout.setViewFrame(_:))
        }.overlay(
            ZStack(alignment: .top) {
                VacuumMouth(isExtended: vacuuming)
                    .animation(.default)
                    .opacity(vacuuming ? 1 : 0)

                if showMetalView {
                    VacuumSceneView(
                        image: vacuumLayout.image,
                        frames: vacuumLayout.frames,
                        sourceFrames: vacuumLayout.sourceFrames,
                        duration: vacuumDuration,
                        insets: EdgeInsets()
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }.ignoresSafeArea(),
            alignment: .top
        )
    }

    @MainActor
    func deleteAll() async {
        vacuumLayout.image = AlbumScreen(
            pictures: pictures,
            onVisibleFramesChange: { _ in },
            onDeleteAll: { }
        )
        .environmentObject(imageLoader)
        .renderUIImage(size: vacuumLayout.imageSize)

        showMetalView = true

        try? await Task.sleep(nanoseconds: NSEC_PER_MSEC * 1)

        vacuuming = true
        pictures = []

        try? await Task.sleep(nanoseconds: NSEC_PER_SEC * UInt64(vacuumDuration))
        showMetalView = false
        vacuuming = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ImageLoader())
    }
}
