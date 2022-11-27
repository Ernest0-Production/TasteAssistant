//
//  FoodNameEditorView.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct FoodNameEditorView: View {
    @Binding var name: String

    var body: some View {
        TextField("name", text: $name)
    }
}
