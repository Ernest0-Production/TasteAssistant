//
//  FoodTagEditorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 28.11.2022.
//

import SwiftUI

struct FoodTagEditorView: View {
    @Binding var tag: Food.Tag?

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

                    tag = newTag

                    clear()
                }

            ColorPicker("Tag color", selection: $color)
                .labelsHidden()

            RemoveTagButton {
                tag = nil
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
        .onAppear {
            if let tag {
                name = tag.name
                color = tag.backgroundColor
            }
        }
    }

    func clear() {
        name = ""
        color = .clear
    }
}
