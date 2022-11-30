//
//  FoodTagsEditorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

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

    var inputTransition: AnyTransition {
        .opacity
        .combined(with: .scale)
        .animation(.default)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            switch mode {
            case .idle:
                AddTagButton {
                    mode = .tagCreation
                }
                .transition(inputTransition)

            case .tagCreation:
                FoodTagCreatorView(
                    onSubmit: { newTag in
                        withAnimation {
                            tags.insert(newTag, at: .zero)
                        }
                    },
                    onCancel: {
                        mode = .idle
                    }
                )
                .focused($fieldFocus)
                .transition(inputTransition)
                .onAppear {
                    fieldFocus = true
                }

            case let .tagEditing(tagId):
                if let tag = tags[id: tagId] {
                    FoodTagEditorView(
                        tag: tag,
                        onSave: { updatedTag in
                            tags[id: tagId] = updatedTag
                            mode = .idle
                        },
                        onDelete:  {
                            tags[id: tagId] = nil
                            mode = .idle
                        }
                    )
                    .focused($fieldFocus)
                    .transition(inputTransition)
                    .onAppear {
                        fieldFocus = true
                    }
                }
            }

            EditableTagsView(
                tags: $tags,
                editingTag: Binding
                    .get { mode.editingTag }
                    .set { tagId in
                        if let tagId {
                            mode = .tagEditing(tagId)
                        } else {
                            mode = .idle
                        }
                    }
            )
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
        if !visibleTags.isEmpty {
            FlowLayout(itemSpacing: 8, lineSpacing: 8) {
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
            .animation(.default, value: visibleTags.map(\.id))
        }
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
