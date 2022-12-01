//
//  FoodEditorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 28.11.2022.
//

import SwiftUI

struct FoodEditorView: View {
    let food: Food
    let onSave: (Food) -> Void
    let onDelete: () -> Void
    let onCancel: () -> Void

    @State private var foodName: String = ""
    @State private var tags: [Food.Tag] = []

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
                    FoodTagsEditorView(tags: $tags)
                        .focused($fieldFocus, equals: Field.tagName)
                }

                DeleteFoodButton {
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
                        let updatedFood = Food(
                            name: foodName,
                            tags: tags
                        )

                        onSave(updatedFood)
                    }
                    .disabled(foodName == "")
                }
            }
        )
        .onFirstAppear {
            foodName = food.name
            tags = food.tags
        }
        .confirmationDialog(
            "Confirm deletion",
            isPresented: $isConfirmDeletionPresented,
            actions: {
                Button("Delete", role: .destructive) {
                    onDelete()
                }
            }
        )
        .confirmationDialog(
            "Confirm cancellation",
            isPresented: $isConfirmCancellationPresented,
            actions: {
                Button("Yes", role: .destructive) {
                    onCancel()
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
