//
//  FoodRowView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct FoodRowView: View {
    @Environment(\.tags) @Binding var tagsTable

    let food: Food


    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(food.name)

            let tags = food.tags.compactMap { tagsTable[id: $0] }
            if !tags.isEmpty {
                FlowLayout(itemSpacing: 4, lineSpacing: 4) {
                    ForEach(tags) { tag in
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
                "ONE",
                "TWO",
                "THREE",
                "FOUR",
                "FIVE",
                "SIX",
                "SEVEN",
            ]
        ))
        .previewLayout(.sizeThatFits)
    }
}
