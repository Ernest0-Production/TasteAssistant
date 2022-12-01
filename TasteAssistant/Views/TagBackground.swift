//
//  TagBackground.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 01.12.2022.
//

import SwiftUI

struct TagBackground: View {
    let color: Color
    let cornerRadius: CGFloat = 12

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius)

        if color == .clear {
            shape.strokeBorder(.gray, lineWidth: 2)
        } else {
            shape.fill(color)
        }
    }
}
