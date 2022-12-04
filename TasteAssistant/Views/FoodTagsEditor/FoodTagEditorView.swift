//
//  FoodTagEditorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 28.11.2022.
//

import SwiftUI

struct FoodTagEditorView: View {
    let tag: TagValue
    let onSave: (TagValue) -> Void
    let onDelete: () -> Void

    struct TagValue {
        let name: String
        let color: Color
    }

    @State var name: String = ""
    @State var color: Color = .clear

    @FocusState var fieldFocus: Bool

    var body: some View {
        Layout(
            field: {
                TextField("Type tag name...", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .focused($fieldFocus)
                    .onSubmit {
                        guard !name.isEmpty else { return }

                        let updatedTag = TagValue(
                            name: name,
                            color: color
                        )

                        onSave(updatedTag)

                        clear()
                    }
            },

            accessory: {
                ColorPicker("Tag color", selection: $color)
                    .labelsHidden()

                RemoveFoodTagButton {
                    onDelete()
                    clear()
                }
            },

            toolbar: {
                if fieldFocus {
                    ToolbarItem(placement: .keyboard) {
                        ColorPicker("Color", selection: $color)
                    }
                }
            }
        )
        .onFirstAppear {
            name = tag.name
            color = tag.color
        }
    }

    func clear() {
        name = ""
        color = .clear
    }
}

private extension FoodTagEditorView {
    struct Layout<
        Field: View,
        Accessory: View,
        Toolbar: ToolbarContent
    >: View {
        @ViewBuilder var field: Field
        @ViewBuilder var accessory: Accessory
        @ToolbarContentBuilder var toolbar: Toolbar

        var body: some View {
            HStack {
                field
                accessory
            }
            .toolbar {
                toolbar
            }
        }
    }
}
