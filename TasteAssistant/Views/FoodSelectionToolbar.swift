//
//  FoodSelectionToolbar.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct FoodSelectionToolbar: ToolbarContent {
    @Binding var allFoods: [Food]
    @Binding var selectedFoods: Set<Food.ID>

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            #warning("Экспортировать выбранные файлы")
            
            Text("Selected: \(selectedFoods.count)")

            Spacer()

            DeleteSelectedFoodsButton {
                allFoods.removeAll { selectedFoods.contains($0.id) }
                selectedFoods = []
            }
        }
    }
}
