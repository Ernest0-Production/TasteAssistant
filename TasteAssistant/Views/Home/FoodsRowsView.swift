//
//  FoodsRowsView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 01.12.2022.
//

import SwiftUI

struct FoodsRowsView: View {
    let foods: [Food]
    private(set) var onTap: (Food) -> Void = { _ in }

    var body: some View {
        ForEach(foods) { food in
            FoodRowView(food: food)
                .listRowInsets(EdgeInsets())
                .tag(food.id)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle()) // Для того чтоб срабатывал обработчик на прозрачном контенте
                .onTapGesture {
                    onTap(food)
                }
        }
    }
}
