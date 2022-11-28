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
        HStack {
            Text(tag.name)
                .onTapGesture(perform: onEdit)

            RemoveTagButton(action: onDelete)
        }
        .padding(8)
        .background {
            if tag.backgroundColor == .clear {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 2)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(tag.backgroundColor)
            }
        }
        .padding(1)
    }
}
