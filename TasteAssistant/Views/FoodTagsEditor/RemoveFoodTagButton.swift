//
//  RemoveFoodTagButton.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 28.11.2022.
//

import SwiftUI

struct RemoveFoodTagButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Image(systemName: "xmark.circle.fill")
        })
        .tint(Color.black.opacity(0.5))
        .buttonStyle(.borderless) // BUG: Без задания стиля при нажатии удаляются все тэги...
    }
}
