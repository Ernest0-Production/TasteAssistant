//
//  AddFoodTagButton.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 28.11.2022.
//

import SwiftUI

struct AddFoodTagButton: View {
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
                        .fill(Color(.systemGray4))
                }
        })
        .buttonStyle(.borderless) // BUG: Без задания стиля при нажатии удаляются все тэги...
    }
}
