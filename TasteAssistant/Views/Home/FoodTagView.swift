//
//  FoodTagView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct FoodTagView: View {
    let tag: Food.Tag

    var body: some View {
        Layout(
            label: {
                Text(tag.name)
            },

            background: {
                TagBackground(color: tag.backgroundColor)
            }
        )
    }
}

private extension FoodTagView {
    struct Layout<
        TagLabel: View,
        Background: View
    >: View {
        @ViewBuilder var label: TagLabel
        @ViewBuilder var background: Background

        var body: some View {
            label
                .padding(8)
                .background {
                    background
                }
        }
    }
}
