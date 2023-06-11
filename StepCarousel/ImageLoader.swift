//
//  ImageLoader.swift
//  StepCarousel
//
//  Created by Umur Gedik on 11.06.2023.
//

import SwiftUI

@MainActor
class ImageLoader: ObservableObject {
    enum ImageState {
        case loading(Task<Void, Never>?)
        case success(Image)
        case failure
    }

    @Published var images: [URL: ImageState] = [:]

    private let urlSession: URLSession
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    public func image(for url: URL) -> ImageState {
        if let state = images[url] {
            return state
        }

        return .loading(nil)
    }

    public func loadImage(for url: URL) {
        guard images[url] == nil else { return }
        images[url] = .loading(Task.detached { await self.fetch(url: url) })
    }

    public func prefetch(urls: [URL]) {
        for url in urls {
            images[url] = .loading(Task.detached { await self.fetch(url: url) })
        }
    }

    private func setImageState(_ state: ImageState, for url: URL) {
        self.images[url] = state
    }


    private nonisolated func fetch(url: URL) async {
        do {
            let (data, _) = try await self.urlSession.data(from: url)
            guard let image = UIImage(data: data) else {
                await self.setImageState(.failure, for: url)
                return
            }

            await self.setImageState(.success(Image(uiImage: image)), for: url)
        } catch {
            await self.setImageState(.failure, for: url)
        }
    }
}

struct RemoteImage: View {
    let url: URL
    @EnvironmentObject var imageLoader: ImageLoader

    var body: some View {
        ZStack {
            switch imageLoader.image(for: url) {
            case .loading:
                ProgressView()
            case .success(let image):
                image
                    .resizable().aspectRatio(contentMode: .fill)
            case .failure:
                Image(systemName: "xmark.octagon.fill").foregroundColor(.red)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .onAppear {
            imageLoader.loadImage(for: url)
        }
    }
}
