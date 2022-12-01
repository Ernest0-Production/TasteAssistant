//
//  FoodRowView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct FoodRowView: View {
    let food: Food

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(food.name)

            if !food.tags.isEmpty {
                FlowLayout(itemSpacing: 4, lineSpacing: 4) {
                    ForEach(food.tags) { tag in
                        FoodTagView(tag: tag)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

struct FoodRowViewProvider_Previews: PreviewProvider {
    static var previews: some View {
        FoodRowView(food: Food(
            name: "NAME",
            tags: [
                Food.Tag(name: "ONE", backgroundColor: .red),
                Food.Tag(name: "TWO", backgroundColor: .clear),
                Food.Tag(name: "THREE", backgroundColor: .blue),
                Food.Tag(name: "FOUR", backgroundColor: .yellow),
                Food.Tag(name: "FIVE", backgroundColor: .clear),
                Food.Tag(name: "SIX", backgroundColor: .clear),
                Food.Tag(name: "SEVEN", backgroundColor: .clear),
            ]
        ))
        .previewLayout(.sizeThatFits)
    }
}
