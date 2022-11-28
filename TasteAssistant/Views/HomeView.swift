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
    @State var presentedFood: Food?

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
                                isFoodCreatorPresented = false
                                withAnimation {
                                    foods.insert(newFood, at: .zero)
                                }
                            },
                            onCancel: {
                                isFoodCreatorPresented = false
                            }
                        )
                        .interactiveDismissDisabled()
                    }
                } else if editMode == .active, !foods.isEmpty {
                    let isSelected = selectedFoods.count == foods.count
                    SelectAllButton(isSelected: isSelected) {
                        if isSelected {
                            selectedFoods = []
                        } else {
                            selectedFoods = Set(foods.map(\.id))
                        }
                    }
                }

                FoodsRowsView(
                    foods: foods,
                    isDisabled: editMode == .active,
                    onTap: { food in
                        presentedFood = food
                    }
                )
                .sheet(item: $presentedFood) { food in
                    FoodEditorView(
                        food: $foods[id: food.id].onSet { presentedFood = nil },
                        onCancel: {
                            presentedFood = nil
                        }
                    )
                }
            }
            .navigationTitle("Foods")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem {
                    EditButton()
                }

                if editMode == .active, !foods.isEmpty {
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
    let isDisabled: Bool
    let onTap: (Food) -> Void

    var body: some View {
        ForEach(foods) { food in
            FoodRowView(food: food)
                .listRowInsets(EdgeInsets())
                .tag(food.id)
                .disabled(isDisabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle()) // Для того чтоб срабатывал обработчик на прозрачном контенте
                .onTapGesture {
                    onTap(food)
                }
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
