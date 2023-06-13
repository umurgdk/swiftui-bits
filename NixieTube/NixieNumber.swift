//
//  NixieNumber.swift
//  NixieTube
//
//  Created by Umur Gedik on 13.06.2023.
//

import SwiftUI

struct NixieNumber: View {
    let number: Int
    let minimumDigits: Int

    init(_ number: Int, minimumDigits: Int = 4) {
        self.number = number
        self.minimumDigits = minimumDigits
    }

    var digits: [Int] {
        var arr: [Int] = []
        var num = number

        while num > 0 {
            arr.insert(num % 10, at: 0)
            num = num / 10
        }

        while arr.count < minimumDigits {
            arr.insert(-1, at: 0)
        }

        return arr
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<digits.count, id: \.self) { i in
                NixieDigit(digits[i])
                    .overlay(
                        Color.red
                            .mask(NixieDigit(digits[i]))
                            .blur(radius: 5)
                            .opacity(0.5)
                            .blendMode(.plusLighter))
                    .padding(.horizontal, 5)
                    .drawingGroup()
                    .transaction { transaction in
                        transaction.animation = transaction.animation?.delay(Double(digits.count - i) * 0.1)
                    }
            }
        }
    }
}

struct NixieDigit: View {
    let digit: Int
    let chars = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

    init(_ digit: Int) {
        self.digit = digit
    }

    var body: some View {
        ZStack {
            ForEach(0...9, id: \.self) { i in
                let isActive = i == digit

                ZStack {
                    Text(chars[i])
                        .opacity(isActive ? 1 : 0.035)

                    if i == digit {
                        Text(chars[i])
                            .blur(radius: 6)
                            .id(digit)
                            .transition(.opacity)

                    }
                }
            }.blendMode(.plusLighter)
        }.foregroundColor(.orange)
    }
}
