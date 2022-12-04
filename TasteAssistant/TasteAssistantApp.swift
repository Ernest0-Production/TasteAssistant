//
//  TasteAssistantApp.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

@main
struct TasteAssistantApp: App {
    @State var foodTable = Table<Food>()
    @State var tagTable = Table<Food.Tag>()
    
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.foods, $foodTable)
                .environment(\.tags, $tagTable)
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .background:
                try? FoodsJSON(
                    foods: Array(foodTable.all()),
                    tags: Array(tagTable.all())
                )
                .write(to: .localFoodsJsonURL)

            case .active:
                if let foodsJSON = try? FoodsJSON(from: .localFoodsJsonURL) {
                    foodTable.insert(foodsJSON.toFoodsModel())
                    tagTable.insert(foodsJSON.toFoodTagsModel())
                }

            default:
                break
            }
        }
    }
}
