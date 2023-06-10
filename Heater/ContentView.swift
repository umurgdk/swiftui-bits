//
//  ContentView.swift
//  Heater
//
//  Created by Umur Gedik on 10.06.2023.
//

import SwiftUI

extension RandomAccessCollection where Index == Int {
    func element<T: BinaryFloatingPoint>(at value: T, in range: ClosedRange<T>) -> Element {
        let normalized = (value - range.lowerBound) / range.upperBound
        let index = floor(normalized * T(self.count - 1))
        return self[Int(index)]
    }
}

struct ContentView: View {
    @State var temperature = Measurement(value: 35, unit: UnitTemperature.celsius)

    var temperatureColor: Color {
        LiquidTube.Palette.default.colors
            .reversed()
            .element(at: temperature.value, in: 0...50)
    }

    var body: some View {
        VStack {
            LiquidTube(
                value: temperature.value,
                range: 0...50
            ).frame(maxHeight: .infinity)

            Spacer()

            Slider(value: $temperature.value.animation(nil), in: 0...50)
                .padding(.horizontal, 24)
                .tint(temperatureColor)
                .animation(.easeOut(duration: 1), value: temperatureColor)

            HStack {
                Button("Cold") {
                    temperature.value = 0
                }.buttonStyle(.heaterCold.selected(temperature.value == 0))
                Spacer()
                Button("Mild") {
                    temperature.value = 25
                }.buttonStyle(.heaterMild.selected(temperature.value == 25))
                Spacer()
                Button("Hot") {
                    temperature.value = 50
                }.buttonStyle(.heaterHot.selected(temperature.value == 50))
            }
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .padding()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.96).ignoresSafeArea())
    }
}

struct HeaterButtonStyle: ButtonStyle {
    let systemImage: String
    let color: Color
    var selected: Bool

    var circleColor: Color {
        if selected {
            return color.opacity(0.15)
        } else {
            return Color.primary.opacity(0.05)
        }
    }

    var iconColor: Color {
        if selected {
            return color
        } else {
            return Color.primary.opacity(0.35)
        }
    }

    func selected(_ value: Bool) -> Self {
        HeaterButtonStyle(systemImage: systemImage, color: color, selected: value)
    }

    func makeBody(configuration: Configuration) -> some View {
        Circle()
            .fill(circleColor)
            .overlay(Image(systemName: systemImage).foregroundColor(iconColor))
            .frame(width: selected ? 60 : 50)
            .frame(width: 60, height: 60)
            .animation(.easeOut, value: selected)
    }
}

extension ButtonStyle where Self == HeaterButtonStyle {
    static func heater(systemImage: String, color: Color, selected: Bool = false) -> Self {
        HeaterButtonStyle(systemImage: systemImage, color: color, selected: selected)
    }

    static var heaterCold: Self { heater(systemImage: "snowflake", color: Color.blue) }
    static var heaterMild: Self { heater(systemImage: "drop.fill", color: Color.yellow) }
    static var heaterHot: Self { heater(systemImage: "flame.fill", color: Color.red) }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
