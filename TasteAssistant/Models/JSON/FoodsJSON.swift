//
//  FoodsJSON.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 04.12.2022.
//

import SwiftUI

extension URL {
    static let localFoodsJsonURL = URL
        .documentsDirectory
        .appendingPathComponent("foods")
        .appendingPathExtension("json")
}

struct FoodsJSON: Codable {
    let foods: [FoodJSON]

    struct FoodJSON: Codable {
        let id: UUID
        let name: String
        let tags: [UUID]
    }

    let tags: [TagJSON]

    struct TagJSON: Codable {
        let id: UUID
        let name: String
        let backgroundColor: Color
    }
}

extension FoodsJSON {
    init(foods: [Food], tags: [Food.Tag]) {
        self.init(
            foods: foods.map {
                FoodJSON(id: $0.id, name: $0.name, tags: Array($0.tags))
            },
            tags: tags.map {
                TagJSON(id: $0.id, name: $0.name, backgroundColor: $0.backgroundColor)
            }
        )
    }

    func toFoodsModel() -> [Food] {
        foods.map {
            Food(id: $0.id, name: $0.name, tags: Set($0.tags))
        }
    }

    func toFoodTagsModel() -> [Food.Tag] {
        tags.map {
            Food.Tag(id: $0.id, name: $0.name, backgroundColor: $0.backgroundColor)
        }
    }
}
