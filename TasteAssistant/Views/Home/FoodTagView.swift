//
//  FoodTagView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct FoodTagView: View {
    let name: String
    let backgroundColor: Color

    var body: some View {
        Layout(
            label: {
                Text(name)
            },

            background: {
                TagBackground(color: backgroundColor)
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

struct FoodTagView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FoodTagView(name: "NAME", backgroundColor: .red)
            FoodTagView(name: "NAME", backgroundColor: .blue)
            FoodTagView(name: "NAME", backgroundColor: .clear)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
