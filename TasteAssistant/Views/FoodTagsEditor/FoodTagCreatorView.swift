//
//  FoodTagCreatorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 28.11.2022.
//

import SwiftUI

struct FoodTagCreatorView: View {
    let onSubmit: (Food.Tag) -> Void
    var onCancel: () -> Void = {}

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

                        let newTag = Food.Tag(
                            name: name,
                            backgroundColor: color
                        )

                        onSubmit(newTag)

                        clear()
                        fieldFocus = true
                    }
            },

            accessory: {
                ColorPicker("Tag color", selection: $color)
                    .labelsHidden()
            },

            toolbar: {
                if fieldFocus {
                    ToolbarItem(placement: .keyboard) {
                        ColorPicker("Color", selection: $color)
                    }
                }
            }
        )
        .onChange(of: fieldFocus) { isFocused in
            // BUG
            if !isFocused && name.isEmpty {
                onCancel()
            }
        }
    }

    func clear() {
        name = ""
        color = .clear
    }
}

private extension FoodTagCreatorView {
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
