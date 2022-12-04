//
//  Food.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct Food: Identifiable {
    let id = UUID()

    var name: String

    var tags: Set<Tag.ID>

    struct Tag: Identifiable, Hashable {
        let id = UUID()

        var name: String
        
        var backgroundColor: Color
    }
}
