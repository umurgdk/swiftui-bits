//
//  Wave.swift
//  SwiftUIBits
//
//  Created by Umur Gedik on 9.06.2023.
//

import SwiftUI

struct Wave: View {
    let value: Double
    var direction: Direction = .forward
    var height: Double = 15

    @State var phase = Double(0)
    @State var lastAnimationAt = Date.distantPast

    let animationDuration: TimeInterval = 1
    enum Direction { case forward, backward }

    public var body: some View {
        WaveShape(frequency: 1, phase: phase).fill()
            .frame(height: 15)
            .animation(.easeOut(duration: animationDuration), value: phase)
            .onAppear { animateWave() }
            .onChange(of: value) { _ in animateWave() }
    }

    func animateWave() {
        let sinceLastAnimation = Date().timeIntervalSince(lastAnimationAt)
        if  sinceLastAnimation > animationDuration {
            let multiplier: Double = direction == .forward ? 1 : -1
            phase += multiplier * Double.pi * 4
            lastAnimationAt = Date()
        }
    }
}

struct WaveShape: Shape {
    let frequency: Double
    var phase: Double

    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        Path { p in
            let waveLength = rect.width / (frequency * Double.pi)
            let halfHeight = rect.height / 2

            p.move(to: CGPoint(x: 0, y: rect.height))
            p.addLine(to: CGPoint(x: 0, y: sin(phase) * halfHeight + rect.midY))
            for i in stride(from: 1, to: rect.width, by: 1) {
                let output = sin(i / waveLength + phase)
                let point = CGPoint(x: i, y: output * halfHeight + rect.midY)
                p.addLine(to: point)
            }
            p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        }
    }
}

struct Arc_Previews: PreviewProvider {
    static var previews: some View {
        Wave(value: 1).frame(width: 70)
    }
}
