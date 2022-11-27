//
//  TasteAssistantApp.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 27.11.2022.
//

import SwiftUI

@main
struct TasteAssistantApp: App {

    var body: some Scene {
        WindowGroup {
            HomeView(foods: [
                Food(
                    name: "APPLE",
                    tags: [
                        Food.Tag(name: "asdasd", backgroundColor: .clear),
                        Food.Tag(name: "12weqqwe", backgroundColor: .red),
                    ]
                ),

                Food(
                    name: "BANANA",
                    tags: [
                        Food.Tag(name: "asdasd", backgroundColor: .clear),
                        Food.Tag(name: "12weqqwe", backgroundColor: .red),
                    ]
                )
            ])
        }
    }
}
