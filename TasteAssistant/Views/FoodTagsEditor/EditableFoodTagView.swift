//
//  EditableFoodTagView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 28.11.2022.
//

import SwiftUI

struct EditableFoodTagView: View {
    let name: String
    let backgroundColor: Color
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        Layout(
            label: {
                Text(name).onTapGesture(perform: onEdit)
            },

            accessory: {
                RemoveFoodTagButton(action: onDelete)
            },

            background: {
                TagBackground(color: backgroundColor)
            }
        )
    }
}

private extension EditableFoodTagView {
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
            EditableFoodTagView(
                name: "NAME",
                backgroundColor: .clear,
                onEdit: {},
                onDelete: {}
            )
            EditableFoodTagView(
                name: "NAME",
                backgroundColor: .red,
                onEdit: {},
                onDelete: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
