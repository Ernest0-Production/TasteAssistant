//
//  DeleteFoodButton.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 29.11.2022.
//

import SwiftUI

struct DeleteFoodButton: View {
    let action: () -> Void

    var body: some View {
        Button(
            "\(Image(systemName: "trash.fill")) Delete Food",
            role: .destructive,
            action: action
        )
    }
}
