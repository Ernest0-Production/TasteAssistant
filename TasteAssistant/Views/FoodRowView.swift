//
//  FoodRowView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct FoodRowView: View {
    let food: Food

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(food.name)
                .padding(.horizontal, 16)

            if !food.tags.isEmpty {
                #warning("Автоперенос тэгов вместо скрола")
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(food.tags) { tag in
                            TagView(tag: tag)
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
