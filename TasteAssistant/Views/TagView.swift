//
//  TagView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct TagView: View {
    let tag: Food.Tag

    var body: some View {
        Text(tag.name)
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
