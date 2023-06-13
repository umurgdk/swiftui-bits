//
//  ContentView.swift
//  NixieTube
//
//  Created by Umur Gedik on 13.06.2023.
//

import SwiftUI

struct ContentView: View {
    @State var number = 7856

    var body: some View {
        ZStack {
            NixieNumber(number)
                .font(.system(size: 80, weight: .thin, design: .rounded))

            Button("Random Number") {
                withAnimation(.default) {
                    number = Int.random(in: 0...9999)
                }
            }
            .foregroundColor(.orange)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
