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
    @Environment(\.foods) var foodsTable

    @State var isFoodCreatorPresented = false
    @State var presentedFood: Food?

    var body: some View {
        Layout(content: {
            AddFoodButton {
                isFoodCreatorPresented = true
            }

            FoodsRowsView(onTap: { food in
                presentedFood = food
            })
            .navigationTitle("Foods")
        })
        .sheet(isPresented: $isFoodCreatorPresented) {
            FoodCreatorView(
                onSave: { _ in
                    isFoodCreatorPresented = false
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
                onSave: { _ in
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
    struct Layout<Content: View>: View {
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
