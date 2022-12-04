//
//  FoodsEnvironmentKey.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 04.12.2022.
//

import SwiftUI

private struct FoodsEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<Table<Food>> {
        Binding.get { Table () }
    }
}

extension EnvironmentValues {
    var foods: Binding<Table<Food>> {
        get { self[FoodsEnvironmentKey.self] }
        set { self[FoodsEnvironmentKey.self] = newValue}
    }
}
