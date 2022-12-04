//
//  TasteAssistantApp.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

@main
struct TasteAssistantApp: App {
    @State var foodTable = Samples.foods {
        didSet {
            #warning("Грузить откуда то данные")
        }
    }

    @State var tagTable = Samples.tags

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.foods, $foodTable)
                .environment(\.tags, $tagTable)
        }
    }
}

// MARK: - Samples

enum Samples {
    static let foods = Table([
        Food(
            name: "APPLE",
            tags: [
                Samples.tags.all().randomElement()!.id,
                Samples.tags.all().randomElement()!.id,
            ]
        ),

        Food(
            name: "BANANA",
            tags: [
                Samples.tags.all().randomElement()!.id,
                Samples.tags.all().randomElement()!.id,
            ]
        )
    ])

    static let tags = Table([
        Food.Tag(name: "asd", backgroundColor: .red),
        Food.Tag(name: "dasds", backgroundColor: .blue),
        Food.Tag(name: "wqew", backgroundColor: .clear),
        Food.Tag(name: "another one", backgroundColor: .yellow),
    ])
}

// MARK: - Environments

struct FoodsEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<Table<Food>> {
        Binding.get { Table () }
    }
}

struct FoodTagsEnvironemtnKey: EnvironmentKey {
    static var defaultValue: Binding<Table<Food.Tag>> {
        Binding.get { Table() }
    }
}

extension EnvironmentValues {
    var foods: Binding<Table<Food>> {
        get { self[FoodsEnvironmentKey.self] }
        set { self[FoodsEnvironmentKey.self] = newValue}
    }

    var tags: Binding<Table<Food.Tag>> {
        get { self[FoodTagsEnvironemtnKey.self] }
        set { self[FoodTagsEnvironemtnKey.self] = newValue}
    }
}
