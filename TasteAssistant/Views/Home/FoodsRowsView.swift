//
//  FoodsRowsView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 01.12.2022.
//

import SwiftUI

struct FoodsRowsView: View {
    let foods: [Food]

    struct Food: Identifiable {
        let id: AnyHashable
        let title: String
        let tags: [FoodRowView.Tag]
        let onTap: () -> Void
    }

    var body: some View {
        ForEach(foods) { food in
            FoodRowView(
                title: food.title,
                tags: food.tags
            )
            .listRowInsets(EdgeInsets())
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle()) // Для того чтоб срабатывал обработчик на прозрачном контенте
            .tag(food.id)
            .onTapGesture(perform: food.onTap)
        }
    }
}
