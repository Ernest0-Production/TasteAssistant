//
//  EditableTagView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 28.11.2022.
//

import SwiftUI

struct EditableTagView: View {
    let tag: Food.Tag
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        Layout(
            label: {
                Text(tag.name).onTapGesture(perform: onEdit)
            },

            accessory: {
                RemoveTagButton(action: onDelete)
            },

            background: {
                TagBackground(color: tag.backgroundColor)
            }
        )
    }
}

private extension EditableTagView {
    struct Layout<
        TagLabel: View,
        TagAccessory: View,
        Background: View
    >: View {
        @ViewBuilder var label: TagLabel
        @ViewBuilder var accessory: TagAccessory
        @ViewBuilder var background: Background

        var body: some View {
            HStack {
                label
                accessory
            }
            .padding(8)
            .background {
                background
            }
        }
    }
}

struct EditableTagPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EditableTagView(
                tag: Food.Tag(name: "NAME", backgroundColor: Color.clear),
                onEdit: {},
                onDelete: {}
            )
            EditableTagView(
                tag: Food.Tag(name: "NAME", backgroundColor: Color.red),
                onEdit: {},
                onDelete: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
