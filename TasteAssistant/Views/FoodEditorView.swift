//
//  FoodEditorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 28.11.2022.
//

import SwiftUI

struct FoodEditorView: View {
    @Binding var food: Food?
    let onCancel: () -> Void

    @State var foodName: String = ""
    @State var tags: [Food.Tag] = []

    @State var isConfirmCancellationPresented = false
    @State var isConfirmDeletionPresented = false

    @FocusState var foodNameFocus: Bool
    @FocusState var newTagNameFocus: Bool

    var body: some View {
        NavigationView {
            Form {
                Section("name") {
                    FoodNameEditorView(name: $foodName)
                        .focused($foodNameFocus)
                        .onAppear {
                            foodNameFocus = true
                        }
                        .onSubmit {
                            newTagNameFocus = true
                        }
                }

                Section("tags") {
                    FoodTagsEditorView(tags: $tags)
                        .focused($newTagNameFocus)
                }

                DeleteFoodButton {
                    isConfirmDeletionPresented = true
                }
                .confirmationDialog(
                    "Confirm deletion",
                    isPresented: $isConfirmDeletionPresented,
                    actions: {
                        Button("Delete", role: .destructive) {
                            food = nil
                        }
                    }
                )
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("Edit Food")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        isConfirmCancellationPresented = true
                    }
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

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        food = Food(
                            name: foodName,
                            tags: tags
                        )
                    }
                    .disabled(foodName == "")
                }
            }
        }
        .onAppear {
            if let food {
                foodName = food.name
                tags = food.tags
            }
        }
    }
}
