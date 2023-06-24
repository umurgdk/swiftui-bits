//
//  ErrorView.swift
//  Flyer
//
//  Created by Umur Gedik on 23.06.2023.
//

import SwiftUI

struct ErrorView: View {
    let error: AppError
    let onDismiss: () -> Void

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 8) {
                Text("A problem occured")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)

                switch error {
                case .weatherAPIError(.network):
                    Text("Unable to get weather info, seems like your device is offline.")
                case let .weatherAPIError(.notFound(location)):
                    Text("It seems weather info doesn't exist for \(location.name).")
                case .unexpected:
                    Text("Due to an unexpected failure we can't find the weather information.")
                }
            }

            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark").foregroundColor(.white)
            }
        }
        .colorScheme(.dark)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.red.edgesIgnoringSafeArea(.bottom))
        .onAppear {
            print("ERROR:", error)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static let errors: [AppError] = [
        .unexpected(underlying: nil),
        .weatherAPIError(.notFound(PreviewData.locations.first!)),
        .weatherAPIError(.network(nil))
    ]

    static var previews: some View {
        ForEach(errors.enumeratedUI(), id: \.offset) { _, error in
            ErrorView(error: error, onDismiss: {})
        }.previewLayout(.sizeThatFits)
    }
}
