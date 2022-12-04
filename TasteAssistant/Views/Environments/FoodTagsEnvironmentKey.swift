//
//  FoodTagsEnvironmentKey.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 04.12.2022.
//

import SwiftUI

private struct FoodTagsEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<Table<Food.Tag>> {
        Binding.get { Table() }
    }
}

extension EnvironmentValues {
    var tags: Binding<Table<Food.Tag>> {
        get { self[FoodTagsEnvironmentKey.self] }
        set { self[FoodTagsEnvironmentKey.self] = newValue}
    }
}
