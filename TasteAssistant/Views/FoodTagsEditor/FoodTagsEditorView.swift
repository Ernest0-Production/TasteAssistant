//
//  FoodTagsEditorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct FoodTagsEditorView: View {
    let tags: [Tag]
    let onAdd: (Tag.New) -> Void

    struct Tag: Identifiable {
        let id: AnyHashable
        let name: String
        let backgroundColor: Color

        let onUpdate: (Update) -> Void

        struct Update {
            let name: String
            let backgroundColor: Color
        }

        let onDelete: () -> Void

        struct New {
            let name: String
            let backgroundColor: Color
        }
    }

    @State var mode: Mode = .idle

    enum Mode {
        case idle
        case tagCreation
        case tagEditing(Tag.ID)

        var editingTag: Tag.ID? {
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

    @FocusState var fieldFocus

    var inputTransition: AnyTransition {
        .opacity
        .combined(with: .scale)
        .animation(.default)
    }

    var body: some View {
        Layout(
            mode: mode,

            onIdle: {
                AddFoodTagButton {
                    mode = .tagCreation
                }
                .transition(inputTransition)
            },

            onTagCreation: {
                FoodTagCreatorView(
                    onSubmit: { newValue in
                        onAdd(Tag.New(
                            name: newValue.name,
                            backgroundColor: newValue.color
                        ))
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
                        tag: FoodTagEditorView.TagValue(
                            name: tag.name,
                            color: tag.backgroundColor
                        ),
                        onSave: { newValue in
                            tags[id: tagId]?.onUpdate(Tag.Update(
                                name: newValue.name,
                                backgroundColor: newValue.color
                            ))

                            mode = .idle
                        },
                        onDelete:  {
                            tags[id: tagId]?.onDelete()
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

            tagCollection: tags
                .filter { $0.id != mode.editingTag }
                .map { tag in
                    EditableFoodTagView(
                        name: tag.name,
                        backgroundColor: tag.backgroundColor,
                        onEdit: {
                            mode = .tagEditing(tag.id)
                        },
                        onDelete: {
                            tag.onDelete()
                        }
                    )
                }
        )
    }
}

private extension FoodTagsEditorView {
    struct Layout<
        IdleContent: View,
        TagCreationContent: View,
        TagEditingContent: View,
        TagContent: View
    >: View {
        let mode: Mode
        @ViewBuilder var onIdle: IdleContent
        @ViewBuilder var onTagCreation: TagCreationContent
        @ViewBuilder var onTagEditing: (Tag.ID) -> TagEditingContent
        let tagCollection: ContentCollection<[Tag], Tag.ID, TagContent>

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

                if !tagCollection.data.isEmpty {
                    FlowLayout(itemSpacing: 8, lineSpacing: 8) {
                        ForEach(tagCollection)
                    }
                    .animation(.default, value: tagCollection.data.map(\.id))
                }
            }
        }
    }
}

struct FoodTagsEditorView_Previews: PreviewProvider {
    struct Example: View {
        @State var tags: [FoodTagsEditorView.Tag] = [
            FoodTagsEditorView.Tag(id: 1, name: "ONE", backgroundColor: .red, onUpdate: { _ in }, onDelete: { }),
            FoodTagsEditorView.Tag(id: 1, name: "TWO", backgroundColor: .clear, onUpdate: { _ in }, onDelete: { }),
            FoodTagsEditorView.Tag(id: 1, name: "THREE", backgroundColor: .blue, onUpdate: { _ in }, onDelete: { }),
            FoodTagsEditorView.Tag(id: 1, name: "FOUR", backgroundColor: .yellow, onUpdate: { _ in }, onDelete: { }),
            FoodTagsEditorView.Tag(id: 1, name: "FIVE", backgroundColor: .clear, onUpdate: { _ in }, onDelete: { }),
            FoodTagsEditorView.Tag(id: 1, name: "SIX", backgroundColor: .clear, onUpdate: { _ in }, onDelete: { }),
            FoodTagsEditorView.Tag(id: 1, name: "SEVEN", backgroundColor: .clear, onUpdate: { _ in }, onDelete: { }),
        ]

        var body: some View {
            Form {
                FoodTagsEditorView(tags: tags, onAdd: { _ in })
            }
        }
    }

    static var previews: some View {
        Example()
    }
}
