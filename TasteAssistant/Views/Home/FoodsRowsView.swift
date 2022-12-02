//
//  FoodsRowsView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 01.12.2022.
//

import SwiftUI

struct FoodsRowsView: View {
    @Environment(\.foods) @Binding var foodsTable

    private(set) var onTap: (Food) -> Void = { _ in }

    var sortedFoods: [Food] {
        foodsTable.all().sorted { lhs, rhs in
            lhs.name > rhs.name
        }
    }

    var body: some View {
        ForEach(sortedFoods) { food in
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
