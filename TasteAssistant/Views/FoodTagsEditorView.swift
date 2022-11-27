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

    @State var mode: Mode = .idle

    enum Mode {
        case idle
        case newTag
        case editingTag(Food.Tag.ID)
    }

    var shouldShowTags: Bool {
        switch mode {
        case .idle:
            return true
        case .newTag:
            return !tags.isEmpty
        case let .editingTag(tagId):
            return !tags.filter { $0.id != tagId }.isEmpty
        }
    }

    var visibleTags: [Food.Tag] {
        switch mode {
        case .idle:
            return tags
        case .newTag:
            return tags
        case let .editingTag(tagId):
            return tags.filter { $0.id != tagId }
        }
    }

    var body: some View {
        Group {
            switch mode {
            case .idle:
                EmptyView()

            case .newTag:
                HStack {
                    TextField("Type tag name...", text: $newTagName)
                        .focused($newTagNameFocus)
                        .onSubmit {
                            guard !newTagName.isEmpty else { return }

                            let newTag = Food.Tag(
                                name: newTagName,
                                backgroundColor: newTagColor
                            )

                            tags.insert(newTag, at: .zero)

                            newTagName = ""
                            newTagColor = .clear
                            mode = .idle
                            newTagNameFocus = true
                        }
                        .onChange(of: newTagNameFocus) { isFocused in
                            if !isFocused && newTagName.isEmpty {
                                mode = .idle
                            }
                        }

                    ColorPicker("Tag color", selection: $newTagColor)
                        .labelsHidden()
                }

            case let .editingTag(tagId):
                HStack {
                    TextField("Type tag name...", text: $newTagName)
                        .focused($newTagNameFocus)
                        .onSubmit {
                            guard !newTagName.isEmpty else { return }

                            guard let editingTagIndex = tags.firstIndex(where: { $0.id == tagId }) else {
                                return
                            }

                            let newTag = Food.Tag(
                                name: newTagName,
                                backgroundColor: newTagColor
                            )

                            tags[editingTagIndex] = newTag

                            newTagName = ""
                            newTagColor = .clear
                            mode = .idle
                            newTagNameFocus = false
                        }

                    ColorPicker("Tag color", selection: $newTagColor)
                        .labelsHidden()

                    RemoveTagButton {
                        tags.removeAll(where: { $0.id == tagId })
                        newTagName = ""
                        newTagColor = .clear
                        mode = .idle
                        newTagNameFocus = false
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .toolbar {
            if newTagNameFocus {
                ToolbarItem(placement: .keyboard) {
                    ColorPicker("Color", selection: $newTagColor)
                }
            }
        }

        if shouldShowTags {
            FlowLayout(itemSpacing: 8, lineSpacing: 8) {
                if case .idle = mode {
                    AddTagButton {
                        newTagNameFocus = true
                        mode = .newTag
                    }
                }

                if !visibleTags.isEmpty {
                    ForEach(visibleTags) { tag in
                        TagEditorView(
                            tag: tag,
                            onEdit: {
                                newTagNameFocus = true
                                mode = .editingTag(tag.id)
                                newTagName = tag.name
                                newTagColor = tag.backgroundColor
                            },
                            onDelete: {
                                tags.removeAll(where: { $0.id == tag.id })
                            }
                        )
                    }
                }
            }
        }
    }
}

struct AddTagButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Image(systemName: "plus.rectangle.fill")
                .tint(Color.gray)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray3))
                }
                .padding(1)
        })
        .buttonStyle(.borderless) // BUG: Без задания стиля при нажатии удаляются все тэги...
    }
}

struct TagEditorView: View {
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

struct RemoveTagButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Image(systemName: "xmark.circle.fill")
        })
        .tint(Color.black.opacity(0.5))
        .buttonStyle(.borderless) // BUG: Без задания стиля при нажатии удаляются все тэги...
    }
}

struct FoodTagsEditorView_Previews: PreviewProvider {
    struct Example: View {
        @State var tags: [Food.Tag] = [
            Food.Tag(name: "ONE", backgroundColor: .red),
            Food.Tag(name: "TWO", backgroundColor: .clear),
            Food.Tag(name: "THREE", backgroundColor: .blue),
            Food.Tag(name: "FOUR", backgroundColor: .yellow),
            Food.Tag(name: "FIVE", backgroundColor: .clear),
            Food.Tag(name: "SIX", backgroundColor: .clear),
            Food.Tag(name: "SEVEN", backgroundColor: .clear),
        ]

        var body: some View {
            Form {
                FoodTagsEditorView(tags: $tags)
            }
        }
    }

    static var previews: some View {
//        TagEditorView(
//            tag: Food.Tag(name: "ONE", backgroundColor: .red),
//            onEdit: {},
//            onDelete: {}
//        )

        Example()
    }
}
