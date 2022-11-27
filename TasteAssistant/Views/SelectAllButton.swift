//
//  SelectAllButton.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct SelectAllButton: View {
    let isSelected: Bool
    let action: () -> Void

    var checkmarkImageName: String {
        isSelected ? "checkmark.circle.fill" : "checkmark.circle"
    }

    var title: String {
        isSelected ? "Deselect All" : "Select All"
    }

    var body: some View {
        Button(
            "\(Image(systemName: checkmarkImageName)) \(title)",
            action: action
        )
    }
}
