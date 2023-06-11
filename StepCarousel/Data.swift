//
//  Data.swift
//  StepCarousel
//
//  Created by Umur Gedik on 11.06.2023.
//

import Foundation

struct Review: Identifiable {
    let id = UUID()
    let body: String
    let author: Author
    let product: Product
}

struct Author: Identifiable {
    let id = UUID()
    let name: String
    let avatar: URL
}

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let image: URL
}

let reviews = [
    Review(
        body: "I absolutely love this product! It has exceeded my expectations in every way. Highly recommended!",
        author: Author(
            name: "John Doe",
            avatar: URL(string: "https://i.pravatar.cc/300?img=0")!
        ),
        product: Product(
            name: "Last Trip",
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 3))!,
            image: URL(string: "https://picsum.photos/id/1/800/600")!
        )
    ),

    Review(
        body: "I've been using this service for a while now, and I'm extremely satisfied. The customer support is top-notch, and results are fantastic!",
        author: Author(
            name: "Sarah M",
            avatar: URL(string: "https://i.pravatar.cc/300?img=1")!
        ),
        product: Product(
            name: "Last Trip",
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 3))!,
            image: URL(string: "https://picsum.photos/id/100/800/600")!
        )
    ),

    Review(
        body: "I've been using this service for a while now, and I'm extremely satisfied. The customer support is top-notch, and results are fantastic!",
        author: Author(
            name: "Sarah M",
            avatar: URL(string: "https://i.pravatar.cc/300?img=2")!
        ),
        product: Product(
            name: "Last Trip",
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 3))!,
            image: URL(string: "https://picsum.photos/id/120/800/600")!
        )
    )
]
