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

    func clone() -> Self {
        Review(body: body, author: author, product: product.clone())
    }
}

struct Author: Identifiable {
    let id = UUID()
    let name: String
    let avatar: URL

    func clone() -> Self {
        Author(name: name, avatar: avatar)
    }
}

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let image: URL

    func clone() -> Self {
        Product(name: name, date: date, image: image)
    }
}

let reviews = [
    Review(
        body: "I absolutely love this product! It has exceeded my expectations in every way. Highly recommended!",
        author: Author(
            name: "John Doe",
            avatar: URL(string: "https://i.pravatar.cc/300?img=0")!
        ),
        product: Product(
            name: "Tropical Evenings",
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 1))!,
            image: URL(string: "https://picsum.photos/id/110/800/600")!
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
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 2))!,
            image: URL(string: "https://picsum.photos/id/100/800/600")!
        )
    ),

    Review(
        body: "The product is easy to use and provides me with countless features that help me keep track of my tasks, prioritize them, and stay on top of my work. It also allows me to collaborate with team members, set reminders, and organize my workflow.",
        author: Author(
            name: "Johannes Doe",
            avatar: URL(string: "https://i.pravatar.cc/300?img=5")!
        ),
        product: Product(
            name: "Northern Sky",
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 3))!,
            image: URL(string: "https://picsum.photos/id/120/800/600")!
        )
    ),

    Review(
        body: "The interface was modern and visually appealing, and the product included a variety of useful features. Overall, the product was a great experience and I would highly recommend it to anyone looking to increase their productivity.",
        author: Author(
            name: "Juan Fernández",
            avatar: URL(string: "https://i.pravatar.cc/300?img=8")!
        ),
        product: Product(
            name: "The Ocean",
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 4))!,
            image: URL(string: "https://picsum.photos/id/135/800/600")!
        )
    )
]
