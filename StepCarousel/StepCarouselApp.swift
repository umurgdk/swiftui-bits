//
//  StepCarouselApp.swift
//  StepCarousel
//
//  Created by Umur Gedik on 10.06.2023.
//

import SwiftUI

@main
@MainActor
struct StepCarouselApp: App {
    let imageLoader = ImageLoader()
    let demoEnvironment = false

    var body: some Scene {
        WindowGroup {
            if demoEnvironment {
                Demo { index in
                    DemoCard(index: index)
                }
            } else {
                ContentView()
                    .environmentObject(imageLoader)
                    .onAppear {
                        imageLoader.prefetch(urls: reviews.map(\.product.image))
                        imageLoader.prefetch(urls: reviews.map(\.author.avatar))
                    }
            }
        }
    }
}

struct Demo<C: View>: View {
    let content: (Int) -> C
    let numbers = Array(0...1000)
    @State var index = 0
    @State var isShowing = true

    var triplet: [Int] {
        Array(numbers[index...index+3])
    }

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                ForEach(triplet, id: \.self) { index in
                    Color.clear.overlay(
                        content(index)
                    )
                    .id(index)
                    .transition(
                        .modifier(
                            active: DemoTransition(isActive: true),
                            identity: DemoTransition(isActive: false)
                        )
                    )
                }
            }

            Button("Toggle") {
                withAnimation(.easeInOut(duration: 2)) {
                    index += 1
                }
            }

        }
//        .onTapGesture {
//            withAnimation(.easeInOut(duration: 2)) {
//                index += 1
//            }
//        }
    }
}

struct DemoCard: View {
    let index: Int

    @Environment(\.productCarouselReveal) var reveal

    var body: some View {
        ZStack {
            Color.red.layoutPriority(2)
            Text("A")
                .font(.system(size: 50))
                .fixedSize()
//                .aspectRatio(1, contentMode: .fit)
                .blur(radius: (1 - reveal) * 10)
//            Circle().fill(.white).frame(width: 20, height: 20).blur(radius: (1 - reveal) * 10).
        }.drawingGroup()
    }
}


struct DemoTransition: ViewModifier {
    let isActive: Bool
    var reveal: Double { isActive ? 0 : 1 }

    func body(content: Content) -> some View {
        content
            .frame(width: 100, height: 100)
            .compositingGroup()
            .zIndex(isActive ? 10 : 1)
            .scaleEffect(isActive ? 0 : 1)
            .rotationEffect(.radians((1 - reveal + 0.3) * .pi))
            .environment(\.productCarouselReveal, reveal)
    }
}
