//
//  HomeView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

#warning("Импортировать из файла данные")
#warning("Кнопка группировки по тэгам")
#warning("Грузить откуда то данные")

struct HomeView: View {
    @State var foods: [Food] = []

    @State var isFoodCreatorPresented = false
    @State var presentedFood: Food?

    var body: some View {
        Layout(content: {
            AddFoodButton {
                isFoodCreatorPresented = true
            }

            FoodsRowsView(
                foods: foods,
                onTap: { food in
                    presentedFood = food
                }
            )
            .navigationTitle("Foods")
        })
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
        .sheet(item: $presentedFood) { food in
            FoodEditorView(
                food: food,
                onSave: { updatedFood in
                    foods[id: food.id] = updatedFood
                    presentedFood = nil
                },
                onDelete: {
                    presentedFood = nil
                },
                onCancel: {
                    presentedFood = nil
                }
            )
        }
    }
}

private extension HomeView {
    struct Layout<
        Content: View
    >: View {
        @ViewBuilder var content: Content

        var body: some View {
            NavigationView {
                List {
                    content
                }
                .navigationBarTitleDisplayMode(.large)
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
