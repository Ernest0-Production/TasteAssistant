//
//  FoodCreatorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct FoodCreatorView: View {
    let onSave: (Food) -> Void
    let onCancel: () -> Void

    @State var foodName: String = ""
    @State var tags: [Food.Tag] = []

    @State var isConfirmCancellationPresented = false

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

                Section("tag") {
                    FoodTagsEditorView(tags: $tags)
                        .focused($newTagNameFocus)
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("Add Food")
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
                            Text("Are you sure?")
                        }
                    )
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newFood = Food(
                            name: foodName,
                            tags: tags
                        )

                        onSave(newFood)
                    }
                    .disabled(foodName == "")
                }
            }
        }
    }
}
