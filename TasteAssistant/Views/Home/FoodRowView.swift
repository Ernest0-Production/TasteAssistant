//
//  FoodRowView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct FoodRowView: View {
    let title: String
    let tags: [Tag]

    struct Tag: Identifiable {
        let id: AnyHashable
        let name: String
        let backgroundColor: Color
    }

    var body: some View {
        Layout(
            label: {
                Text(title)
            },

            tagCollection: tags.map { tag in
                FoodTagView(
                    name: tag.name,
                    backgroundColor: tag.backgroundColor
                )
            }
        )
    }
}

private extension FoodRowView {
    struct Layout<
        Label: View,
        Tag: Identifiable,
        TagContent: View
    >: View {
        @ViewBuilder var label: Label
        let tagCollection: ContentCollection<[Tag], Tag.ID, TagContent>

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                label

                if !tagCollection.data.isEmpty {
                    FlowLayout(itemSpacing: 4, lineSpacing: 4) {
                        ForEach(tagCollection)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

struct FoodRowView_Previews: PreviewProvider {
    static var previews: some View {
        FoodRowView(
            title: "NAME",
            tags: [
                FoodRowView.Tag(id: 1, name: "ONE", backgroundColor: .red),
                FoodRowView.Tag(id: 2, name: "TWO", backgroundColor: .clear),
                FoodRowView.Tag(id: 3, name: "THREE", backgroundColor: .blue),
                FoodRowView.Tag(id: 4, name: "FOUR", backgroundColor: .yellow),
                FoodRowView.Tag(id: 5, name: "FIVE", backgroundColor: .clear),
                FoodRowView.Tag(id: 6, name: "SIX", backgroundColor: .clear),
                FoodRowView.Tag(id: 7, name: "SEVEN", backgroundColor: .clear),
            ]
        )
        .previewLayout(.sizeThatFits)
    }
}
