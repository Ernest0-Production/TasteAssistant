//
//  Binding+element.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 28.11.2022.
//

extension Array where Element: Identifiable {
    subscript(id elementId: Element.ID) -> Element? {
        get {
            first(where: { $0.id == elementId })
        }
        set {
            guard let index = firstIndex(where: { $0.id == elementId }) else {
                return
            }

            if let newValue {
                self[index] = newValue
            } else {
                remove(at: index)
            }
        }
    }
}
