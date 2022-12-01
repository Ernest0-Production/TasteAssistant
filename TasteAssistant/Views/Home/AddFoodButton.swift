//
//  AddFoodButton.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct AddFoodButton: View {
    let action: () -> Void

    var body: some View {
        Button(
            "\(Image(systemName: "plus")) Add Food",
            action: action
        )
    }
}
