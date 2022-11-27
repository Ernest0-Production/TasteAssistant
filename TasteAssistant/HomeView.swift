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
                }

                #warning("Кнопка ВЫБРАТЬ ВСЕ")

            #warning("Редактировать созданные фуды")

                ForEach(foods) { food in
                    FoodRowView(food: food)
                        .listRowInsets(EdgeInsets())
                        .tag(food.id)
                        .disabled(editMode == .active)
                }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(foods: [
            Food(
                name: "Asda",
                tags: [
                    Food.Tag(name: "asdasd", backgroundColor: .clear),
                    Food.Tag(name: "12weqqwe", backgroundColor: .red),
                ]
            )
        ])

        FoodCreatorView(onSave: { _ in }, onCancel: { })
    }
}
