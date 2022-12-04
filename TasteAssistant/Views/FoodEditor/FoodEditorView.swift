//
//  FoodEditorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 28.11.2022.
//

import SwiftUI

struct FoodEditorView: View {
    let food: Food
    let onComplete: () -> Void

    @Environment(\.foods) @Binding var foodTable
    @Environment(\.tags) @Binding var tagTable

    @State private var foodName: String = ""
    @State private var tags: [TemporaryTag] = []

    enum TemporaryTag {
        case existed(Food.Tag)

        case new(New)

        struct New: Identifiable {
            let id = UUID()
            var name: String
            var backgroundColor: Color
        }
    }

    @State private var isConfirmCancellationPresented = false
    @State private var isConfirmDeletionPresented = false

    @FocusState private var fieldFocus: Field?

    enum Field: Hashable {
        case foodName
        case tagName
    }

    var body: some View {
        Layout(
            content: {
                Section("name") {
                    TextField("name", text: $foodName)
                        .focused($fieldFocus, equals: Field.tagName)
                        .onFirstAppear {
                            fieldFocus = .foodName
                        }
                        .onSubmit {
                            fieldFocus = .tagName
                        }
                }
                .navigationTitle("Edit Food")

                Section("tags") {
                    FoodTagsEditorView(
                        tags: Array(temporaryTags: $tags),
                        onAdd: { newValue in
                            tags.insert(
                                .new(TemporaryTag.New(tag: newValue)),
                                at: .zero
                            )
                        }
                    )
                    .focused($fieldFocus, equals: Field.tagName)
                }

                DeleteFoodButton {
                    foodTable.remove(id: food.id)
                    isConfirmDeletionPresented = true
                }
            },

            toolbar: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        isConfirmCancellationPresented = true
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let foodTags: [Food.Tag] = tags.map { temporaryTag in
                            switch temporaryTag {
                            case let .existed(existedTag):
                                return existedTag

                            case let .new(newTag):
                                return newTag.asFoodTag()
                            }
                        }

                        tagTable.insert(foodTags)
                        
                        var updatedFood = food
                        updatedFood.name = foodName
                        updatedFood.tags = Set(foodTags.map(\.id))

                        foodTable.insert(updatedFood)

                        onComplete()
                    }
                    .disabled(foodName == "")
                }
            }
        )
        .onFirstAppear {
            foodName = food.name
            tags = food.tags
                .compactMap(tagTable.element)
                .sorted(by: \.name.localizedLowercase)
                .map(TemporaryTag.existed)
        }
        .confirmationDialog(
            "Confirm deletion",
            isPresented: $isConfirmDeletionPresented,
            actions: {
                Button("Delete", role: .destructive) {
                    onComplete()
                }
            }
        )
        .confirmationDialog(
            "Confirm cancellation",
            isPresented: $isConfirmCancellationPresented,
            actions: {
                Button("Yes", role: .destructive) {
                    onComplete()
                }
            },
            message: {
                Text("All changes will be discarded. Are you sure?")
            }
        )
    }
}


private extension FoodEditorView {
    struct Layout<
        Content: View,
        Toolbar: ToolbarContent
    >: View {
        @ViewBuilder var content: Content
        @ToolbarContentBuilder var toolbar: Toolbar

        var body: some View {
            NavigationView {
                Form {
                    content
                }
                .scrollDismissesKeyboard(.immediately)
                .toolbar {
                    toolbar
                }
            }
        }
    }
}

private extension FoodTagsEditorView.Tag {
    init(
        existedTag: Food.Tag,
        onUpdate: @escaping (Food.Tag) -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.init(
            id: existedTag.id,
            name: existedTag.name,
            backgroundColor: existedTag.backgroundColor,
            onUpdate: { update in
                var updatedTag = existedTag

                updatedTag.name = update.name
                updatedTag.backgroundColor = update.backgroundColor

                onUpdate(updatedTag)
            },
            onDelete: onDelete
        )
    }

    init(
        newTag: FoodEditorView.TemporaryTag.New,
        onUpdate: @escaping (FoodEditorView.TemporaryTag.New) -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.init(
            id: newTag.id,
            name: newTag.name,
            backgroundColor: newTag.backgroundColor,
            onUpdate: { update in
                var updatedTag = newTag

                updatedTag.name = update.name
                updatedTag.backgroundColor = update.backgroundColor

                onUpdate(updatedTag)
            },
            onDelete: onDelete
        )
    }
}

private extension FoodEditorView.TemporaryTag.New {
    init(tag: FoodTagsEditorView.Tag.New) {
        self.init(
            name: tag.name,
            backgroundColor: tag.backgroundColor
        )
    }

    func asFoodTag() -> Food.Tag {
        Food.Tag(id: .new, name: name, backgroundColor: backgroundColor)
    }
}

private extension Array where Element == FoodTagsEditorView.Tag {
    init(temporaryTags tags: Binding<[FoodEditorView.TemporaryTag]>) {
        self = tags.wrappedValue.indices.map { tagIndex in
            switch tags.wrappedValue[tagIndex] {
            case let .existed(existedTag):
                return FoodTagsEditorView.Tag(
                    existedTag: existedTag,
                    onUpdate: { newValue in
                        tags.wrappedValue[tagIndex] = .existed(newValue)
                    },
                    onDelete: {
                        tags.wrappedValue.remove(at: tagIndex)
                    }
                )

            case let .new(newTag):
                return FoodTagsEditorView.Tag(
                    newTag: newTag,
                    onUpdate: { newValue in
                        tags.wrappedValue[tagIndex] = .new(newValue)
                    },
                    onDelete: {
                        tags.wrappedValue.remove(at: tagIndex)
                    }
                )
            }
        }
    }
}

struct FoodEditorView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, world!")
    }
}
