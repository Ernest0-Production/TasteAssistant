//
//  FoodTagEditorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 28.11.2022.
//

import SwiftUI

struct FoodTagEditorView: View {
    let tag: Food.Tag
    let onSave: (Food.Tag) -> Void
    let onDelete: () -> Void

    @State var name: String = ""
    @State var color: Color = .clear

    @FocusState var fieldFocus: Bool

    var body: some View {
        HStack {
            TextField("Type tag name...", text: $name)
                .textFieldStyle(.roundedBorder)
                .focused($fieldFocus)
                .onSubmit {
                    guard !name.isEmpty else { return }

                    let updatedTag = Food.Tag(
                        name: name,
                        backgroundColor: color
                    )

                    onSave(updatedTag)

                    clear()
                }

            ColorPicker("Tag color", selection: $color)
                .labelsHidden()

            RemoveTagButton {
                onDelete()
                clear()
            }
        }
        .toolbar {
            if fieldFocus {
                ToolbarItem(placement: .keyboard) {
                    ColorPicker("Color", selection: $color)
                }
            }
        }
        .onFirstAppear {
            name = tag.name
            color = tag.backgroundColor
        }
    }

    func clear() {
        name = ""
        color = .clear
    }
}
