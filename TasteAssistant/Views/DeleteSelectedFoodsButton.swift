//
//  DeleteSelectedFoodsButton.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 01.12.2022.
//

import SwiftUI

struct DeleteSelectedFoodsButton: View {
    let action: () -> Void

    var body: some View {
        Button("Delete", role: .destructive) {
            action()
        }
    }
}
