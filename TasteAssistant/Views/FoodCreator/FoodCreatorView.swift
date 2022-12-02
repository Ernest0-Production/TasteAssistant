//
//  FoodCreatorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct FoodCreatorView: View {
    @Environment(\.foods) @Binding var foodsTable
    @Environment(\.tags) @Binding var tagsTable

    let onSave: (Food) -> Void
    let onCancel: () -> Void

    @State private var foodName: String = ""
    @State private var tags: [Food.Tag] = []

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
                        .onFirstAppear {
                            fieldFocus = .foodName
                        }
                        .onSubmit {
                            fieldFocus = .tagName
                        }
                }
                .navigationTitle("Add Food")

                Section("tags") {
                    FoodTagsEditorView(tags: $tags)
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
                        let newFood = Food(
                            name: foodName,
                            tags: Set(tags.map(\.id))
                        )

                        foodsTable.insert(newFood)
                        tagsTable.insert(tags)

                        onSave(newFood)
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
                    onCancel()
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

struct FoodCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        FoodCreatorView(onSave: { _ in }, onCancel: {})
    }
}
