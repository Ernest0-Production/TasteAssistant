//
//  FoodCreatorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct FoodCreatorView: View {
    let onComplete: () -> Void

    @Environment(\.foods) @Binding private var foodTable
    @Environment(\.tags) @Binding private var tagTable

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
                        .onFirstAppear { fieldFocus = .foodName }
                        .onSubmit { fieldFocus = .tagName }
                }
                .navigationTitle("Add Food")

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
            },

            toolbar: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        isConfirmCancellationPresented = true
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let foodTags: [Food.Tag] = tags.map { temporaryTag in
                            switch temporaryTag {
                            case let .existed(foodTag):
                                return foodTag

                            case let .new(newTag):
                                return newTag.asFoodTag()
                            }
                        }

                        tagTable.insert(foodTags)

                        foodTable.insert(Food(
                            name: foodName,
                            tags: Set(foodTags.map(\.id))
                        ))

                        onComplete()
                    }
                    .disabled(foodName == "")
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
                Text("Are you sure?")
            }
        )
    }
}

private extension FoodCreatorView {
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
        newTag: FoodCreatorView.TemporaryTag.New,
        onUpdate: @escaping (FoodCreatorView.TemporaryTag.New) -> Void,
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

private extension FoodCreatorView.TemporaryTag.New {
    init(tag: FoodTagsEditorView.Tag.New) {
        self.init(
            name: tag.name,
            backgroundColor: tag.backgroundColor
        )
    }

    func asFoodTag() -> Food.Tag {
        Food.Tag(name: name, backgroundColor: backgroundColor)
    }
}

private extension Array where Element == FoodTagsEditorView.Tag {
    init(temporaryTags tags: Binding<[FoodCreatorView.TemporaryTag]>) {
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

struct FoodCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        FoodCreatorView(onComplete: {})
    }
}
