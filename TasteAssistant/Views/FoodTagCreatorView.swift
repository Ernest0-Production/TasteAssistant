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
        HStack {
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

            ColorPicker("Tag color", selection: $color)
                .labelsHidden()
        }
        .toolbar {
            if fieldFocus {
                ToolbarItem(placement: .keyboard) {
                    ColorPicker("Color", selection: $color)
                }
            }
        }
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
