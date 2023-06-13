//
//  SlideTransition.swift
//  StepCarousel
//
//  Created by Umur Gedik on 11.06.2023.
//

import SwiftUI

struct SlideTransition: View {
    @ObservedObject var imageLoader = ImageLoader()

    var items: [URL] {
        [
            URL(string: "https://picsum.photos/id/1/800/600")!,
            URL(string: "https://picsum.photos/id/2/800/600")!,
            URL(string: "https://picsum.photos/id/3/800/600")!,
            URL(string: "https://picsum.photos/id/4/800/600")!,
        ]
    }

    @State var index = 0
    @State var goingNext = true

    var hasNextItem: Bool { index < items.count - 1 }
    var hasPreviousItem: Bool { index > 0 }

    var item: URL { items[index] }

    var id: Int { item.hashValue * (goingNext ? 1 : -1) }

    var body: some View {
        ZStack {
            Color.clear.background(
                VStack {
                    switch imageLoader.image(for: item) {
                    case .loading:
                        ProgressView()
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: "xmark.octagon.fill").foregroundColor(.red)
                    }
                }
            )
            .id(item)
            .clipped()
            .padding(48)
            .clipped()
            .cornerRadius(48)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack {
                Button("Previous") {
                    goingNext = false
                    withAnimation {
                        index -= 1
                    }
                }
                .disabled(index == 0)
                .padding()
                .background(Color.white)
                .clipShape(Capsule())

                Button("Next") {
                    goingNext = true
                    withAnimation {
                        index += 1
                    }
                }
                .disabled(index >= items.count - 1)
                .padding()
                .background(Color.white)
                .clipShape(Capsule())
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .animation(.default, value: item)
        .clipped()
        .onAppear { imageLoader.prefetch(urls: items) }
    }
}

struct SlideTransition_Previews: PreviewProvider {
    static var previews: some View {
        SlideTransition()
    }
}
