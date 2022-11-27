//
//  HomeView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct HomeView: View {
    #warning("Грузить откуда то данные")
    @State var foods: [Food] = []

    @State var isFoodCreatorPresented = false

    @State var selectedFoods: Set<Food.ID> = []

    @State var editMode: EditMode = .inactive

    var body: some View {
        NavigationView {
            List(selection: $selectedFoods) {
                #warning("Кнопка группировки по тэгам")
                if editMode == .inactive {
                    AddFoodButton {
                        isFoodCreatorPresented = true
                    }
                    .sheet(isPresented: $isFoodCreatorPresented) {
                        FoodCreatorView(
                            onSave: { newFood in
                                foods.insert(newFood, at: .zero)
                                isFoodCreatorPresented = false
                            },
                            onCancel: {
                                isFoodCreatorPresented = false
                            }
                        )
                        .interactiveDismissDisabled()
                    }
                } else if editMode == .active {
                    let isSelected = selectedFoods.count == foods.count
                    SelectAllButton(isSelected: isSelected) {
                        if isSelected {
                            selectedFoods = []
                        } else {
                            selectedFoods = Set(foods.map(\.id))
                        }
                    }
                }

            #warning("Редактировать созданные фуды")
                FoodsRowsView(
                    foods: foods,
                    isEnabled: editMode == .active
                )
            }
            .navigationTitle("Foods")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem {
                    EditButton()
                }

                if editMode == .active {
                    FoodSelectionToolbar(
                        allFoods: $foods,
                        selectedFoods: $selectedFoods
                    )
                }

                #warning("Импортировать из файла данные")
            }
            .environment(\.editMode, $editMode)
        }
    }
}

private struct FoodsRowsView: View {
    let foods: [Food]
    let isEnabled: Bool

    var body: some View {
        ForEach(foods) { food in
            FoodRowView(food: food)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color(.systemGray6))
                .tag(food.id)
                .disabled(isEnabled)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(foods: [
            Food(
                name: "APPLE",
                tags: [
                    Food.Tag(name: "asdasd", backgroundColor: .clear),
                    Food.Tag(name: "12weqqwe", backgroundColor: .red),
                ]
            ),

            Food(
                name: "BANANA",
                tags: [
                    Food.Tag(name: "asdasd", backgroundColor: .clear),
                    Food.Tag(name: "12weqqwe", backgroundColor: .red),
                ]
            )
        ])

        FoodCreatorView(onSave: { _ in }, onCancel: { })
    }
}
