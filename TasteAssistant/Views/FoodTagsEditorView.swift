//
//  FoodTagsEditorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct FoodTagsEditorView: View {
    @Binding var tags: [Food.Tag]

    @State var newTagName: String = ""
    @State var newTagColor: Color = .clear

    @FocusState var newTagNameFocus: Bool

    var body: some View {
        HStack {
            TextField("Type tag name...", text: $newTagName)
                .focused($newTagNameFocus)
                .onSubmit {
                    let newTag = Food.Tag(
                        name: newTagName,
                        backgroundColor: newTagColor
                    )

                    tags.insert(newTag, at: .zero)

                    newTagName = ""
                    newTagColor = .clear
                    newTagNameFocus = true
                }
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        ColorPicker("Color", selection: $newTagColor)
                    }
                }

            ColorPicker("Tag color", selection: $newTagColor)
                .labelsHidden()
        }

        #warning("Редактировать созданные тэги")

        #warning("Удалять созданные тэги")

        ForEach(tags) { tag in
            Text(tag.name)
        }
    }
}
