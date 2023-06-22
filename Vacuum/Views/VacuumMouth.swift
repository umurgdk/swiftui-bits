//
//  VacuumMouth.swift
//  Vacuum
//
//  Created by Umur Gedik on 22.06.2023.
//

import SwiftUI

struct VacuumMouth: View, Animatable {
    private var extendProgress: Double = 1

    var animatableData: Double {
        get { extendProgress }
        set { extendProgress = newValue }
    }

    init(isExtended: Bool) {
        self.extendProgress = isExtended ? 1 : 0
    }

    var body: some View {
        let _ = print("Progress:", extendProgress)
        Color.black
            .clipShape(RoundedRectangle(cornerRadius: 18.25, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 18.25, style: .continuous).stroke(.white.opacity(0.2), lineWidth: 2))
            .frame(
                width: 105 + extendProgress * 50,
                height: 39
            )
            .padding(.vertical, 10)
    }
}
