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

    @FocusState private var foodNameFocus: Bool
    @FocusState private var newTagNameFocus: Bool

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
                            onDelete()
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
                        let updatedFood = Food(
                            name: foodName,
                            tags: tags
                        )

                        onSave(updatedFood)
                    }
                    .disabled(foodName == "")
                }
            }
        }
        .onFirstAppear {
            foodName = food.name
            tags = food.tags
        }
    }
}


extension View {
    func onFirstAppear(_ perform: @escaping () -> Void) -> some View {
        modifier(FirstAppearViewModifier(perform: perform))
    }
}

private struct FirstAppearViewModifier: ViewModifier {
    @State var didAppear = false
    let perform: () -> Void

    func body(content: Content) -> some View {
        content.onAppear {
            guard !didAppear else { return }
            didAppear = true

            perform()
        }
    }
}
