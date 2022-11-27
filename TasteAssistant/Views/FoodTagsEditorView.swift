//
//  FoodTagsEditorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
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
        .colorPickerKeyboardToolbar(on: $fieldFocus, $color)
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

extension View {
    func colorPickerKeyboardToolbar(
        on focus: FocusState<Bool>.Binding,
        _ binding: Binding<Color>
    ) -> some View {
        toolbar {
            if focus.wrappedValue {
                ToolbarItem(placement: .keyboard) {
                    ColorPicker("Color", selection: binding)
                }
            }
        }
    }
}

struct FoodTagEditorView: View {
    @Binding var tag: Food.Tag?

    @State var name: String = ""
    @State var color: Color = .clear

    @FocusState var fieldFocus: Bool

    var body: some View {
        HStack {
            TextField("Type tag name...", text: $name)
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
        .colorPickerKeyboardToolbar(on: $fieldFocus, $color)
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

struct FoodTagsEditorView: View {
    @Binding var tags: [Food.Tag]

    @State var mode: Mode = .idle

    @FocusState var fieldFocus

    enum Mode {
        case idle
        case tagCreation
        case tagEditing(Food.Tag.ID)

        var editingTag: Food.Tag.ID? {
            switch self {
            case let .tagEditing(tagId):
                return tagId
            case .idle, .tagCreation:
                return nil
            }
        }

        var isIdle: Bool {
            switch self {
            case .idle:
                return true
            case .tagEditing, .tagCreation:
                return false
            }
        }
    }

    var shouldShowTags: Bool {
        switch mode {
        case .idle:
            return true
        case .tagCreation:
            return !tags.isEmpty
        case let .tagEditing(tagId):
            return !tags.filter { $0.id != tagId }.isEmpty
        }
    }

    var body: some View {
        Group {
            switch mode {
            case .idle:
                EmptyView()

            case .tagCreation:
                FoodTagCreatorView(
                    onSubmit: { newTag in
                        tags.insert(newTag, at: .zero)
                    },
                    onCancel: {
                        mode = .idle
                    }
                )
                .focused($fieldFocus)
                .onAppear {
                    fieldFocus = true
                }

            case let .tagEditing(tagId):
                FoodTagEditorView(tag: Binding(
                    get: { tags.first { $0.id == tagId } },
                    set: { newValue in
                        guard let tagIndex = tags.firstIndex(where: { $0.id == tagId }) else {
                            return
                        }

                        if let newValue {
                            tags[tagIndex] = newValue
                        } else {
                            tags.remove(at: tagIndex)
                        }

                        mode = .idle
                    }
                ))
                .focused($fieldFocus)
                .onAppear {
                    fieldFocus = true
                }
            }
        }

        if shouldShowTags {
            FlowLayout(itemSpacing: 8, lineSpacing: 8) {
                if mode.isIdle {
                    AddTagButton {
                        mode = .tagCreation
                    }
                }

                EditableTagsView(
                    tags: $tags,
                    editingTag: Binding(
                        get: { mode.editingTag },
                        set: { tagId in
                            if let tagId {
                                mode = .tagEditing(tagId)
                            } else {
                                mode = .idle
                            }
                        }
                    )
                )
            }
        }
    }
}

struct EditableTagsView: View {
    @Binding var tags: [Food.Tag]
    @Binding var editingTag: Food.Tag.ID?

    var visibleTags: [Food.Tag] {
        if let editingTag {
            return tags.filter { $0.id != editingTag }
        } else {
            return tags
        }
    }

    var body: some View {
        ForEach(visibleTags) { tag in
            EditableTagView(
                tag: tag,
                onEdit: {
                    editingTag = tag.id
                },
                onDelete: {
                    tags.removeAll(where: { $0.id == tag.id })
                }
            )
        }
    }
}

struct AddTagButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Text("+ NEW TAG")
                .bold()
                .tint(Color(.darkGray))
                .padding(.vertical, 8)
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                }
        })
        .buttonStyle(.borderless) // BUG: Без задания стиля при нажатии удаляются все тэги...
    }
}

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
        Example()
    }
}
