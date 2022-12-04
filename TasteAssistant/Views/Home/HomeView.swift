//
//  HomeView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

#warning("Импортировать из файла данные")
#warning("Кнопка группировки по тэгам")

struct HomeView: View {
    @Environment(\.foods) @Binding private var foodTable
    @Environment(\.tags) @Binding private var tagTable

    @State private var isFoodCreatorPresented = false
    @State private var presentedFood: Food?

    var body: some View {
        Layout(content: {
            AddFoodButton {
                isFoodCreatorPresented = true
            }

            FoodsRowsView(
                foods: foodTable.all()
                    .sorted(by: \.name.localizedLowercase)
                    .map { food in
                        FoodsRowsView.Food(
                            model: food,
                            tagTable: tagTable,
                            onTap: { presentedFood = food }
                        )
                    }
            )
            .navigationTitle("Foods")
        })
        .sheet(isPresented: $isFoodCreatorPresented) {
            FoodCreatorView(onComplete: {
                isFoodCreatorPresented = false
            })
            .interactiveDismissDisabled()
        }
        .sheet(item: $presentedFood) { food in
            FoodEditorView(
                food: food,
                onComplete: {
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

private extension FoodsRowsView.Food {
    init(
        model food: Food,
        tagTable: Table<Food.Tag>,
        onTap: @escaping () -> Void
    ) {
        self.init(
            id: food.id,
            title: food.name,
            tags: food.tags
                .lazy
                .compactMap(tagTable.element)
                .compactMap(FoodRowView.Tag.init(model:))
                .sorted(by: \.name.localizedLowercase),
            onTap: onTap
        )
    }
}

private extension FoodRowView.Tag {
    init(model tag: Food.Tag) {
        self.init(
            id: tag.id,
            name: tag.name,
            backgroundColor: tag.backgroundColor
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
