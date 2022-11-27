//
//  Food.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

struct Food: Identifiable {
    var id: String { name }

    var name: String

    var tags: [Tag]

    struct Tag: Identifiable {
        var id: String { name }

        let name: String
        let backgroundColor: Color
    }
}
