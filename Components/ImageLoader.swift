//
//  ImageLoader.swift
//  StepCarousel
//
//  Created by Umur Gedik on 11.06.2023.
//

import SwiftUI

@MainActor
public class ImageLoader: ObservableObject {
    public enum ImageState {
        case loading(Task<Void, Never>?)
        case success(Image)
        case failure
    }

    @Published public var images: [URL: ImageState] = [:]

    private let urlSession: URLSession
    public init(urlSession: URLSession? = nil) {
        if let session = urlSession {
            self.urlSession = session
        } else {
            let cache = URLCache(memoryCapacity: 10_000_000, diskCapacity: 1_000_000_000)
            let config = URLSessionConfiguration.default
            config.urlCache = cache

            self.urlSession = URLSession(configuration: config)
        }
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
            guard let image = PlatformImage(data: data) else {
                print("Failed to load image:", url)
                await self.setImageState(.failure, for: url)
                return
            }

            await self.setImageState(.success(Image(platformImage: image)), for: url)
        } catch {
            print("Failed to load image:", url)
            await self.setImageState(.failure, for: url)
        }
    }
}

public struct RemoteImage: View {
    let url: URL
    @EnvironmentObject var imageLoader: ImageLoader

    public init(url: URL) {
        self.url = url
    }

    public var body: some View {
        ZStack {
            switch imageLoader.image(for: url) {
            case .loading:
                Backport.ProgressView()
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
