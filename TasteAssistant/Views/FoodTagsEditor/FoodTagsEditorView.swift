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
        Layout(
            mode: mode,

            onIdle: {
                AddTagButton {
                    mode = .tagCreation
                }
                .transition(inputTransition)
            },

            onTagCreation: {
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
                .onFirstAppear {
                    fieldFocus = true
                }
            },

            onTagEditing: { tagId in
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
                    .onFirstAppear {
                        fieldFocus = true
                    }
                }
            },

            footer: {
                TagsLayout(tags: tags.filter { $0.id != mode.editingTag }) { tag in
                    EditableTagView(
                        tag: tag,
                        onEdit: {
                            mode = .tagEditing(tag.id)
                        },
                        onDelete: {
                            tags.removeAll(where: { $0.id == tag.id })
                        }
                    )
                }
            }
        )
    }
}

private extension FoodTagsEditorView {
    struct TagsLayout<Content: View>: View {
        let tags: [Food.Tag]
        let content: (Food.Tag) -> Content

        var body: some View {
            if !tags.isEmpty {
                FlowLayout(itemSpacing: 8, lineSpacing: 8) {
                    ForEach(tags) { tag in
                        content(tag)
                    }
                }
                .animation(.default, value: tags.map(\.id))
            }
        }
    }

    struct Layout<
        IdleContent: View,
        TagCreationContent: View,
        TagEditingContent: View,
        FooterContent: View
    >: View {
        let mode: Mode
        @ViewBuilder var onIdle: IdleContent
        @ViewBuilder var onTagCreation: TagCreationContent
        @ViewBuilder var onTagEditing: (Food.Tag.ID) -> TagEditingContent
        @ViewBuilder var footer: FooterContent

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                switch mode {
                case .idle:
                    onIdle
                case .tagCreation:
                    onTagCreation
                case let .tagEditing(tagId):
                    onTagEditing(tagId)
                }

                footer
            }
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
