//
//  Binding+get+set.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 29.11.2022.
//

import SwiftUI

extension Binding {
    static func get(_ get: @escaping () -> Value) -> Binding {
        Binding(
            get: get,
            set: { _ in }
        )
    }

    func set(_ set: @escaping (Value) -> Void) -> Binding {
        Binding(
            get: { wrappedValue },
            set: { set($0) }
        )
    }

    func onGet(_ perform: @escaping () -> Void) -> Binding {
        Binding(
            get: {
                perform()
                return wrappedValue
            },
            set: { newValue, transaction in
                self.transaction(transaction).wrappedValue = newValue
            }
        )
    }

    func onSet(_ perform: @escaping () -> Void) -> Binding {
        Binding(
            get: { wrappedValue },
            set: { newValue, transaction in
                self.transaction(transaction).wrappedValue = newValue
                perform()
            }
        )
    }
}
