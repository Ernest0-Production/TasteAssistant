//
//  Table.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 02.12.2022.
//

import Foundation

struct Table<Element: Identifiable> {
    init(_ elements: any Sequence<Element> = []) {
        self.dict = Dictionary(uniqueKeysWithValues: elements.map { ($0.id, $0) })
    }

    private var dict: [Element.ID: Element]

    var isEmpty: Bool {
        dict.isEmpty
    }

    func all() -> AnyCollection<Element> {
        AnyCollection(dict.values)
    }

    subscript(id elementId: Element.ID) -> Element? {
        dict[elementId]
    }

    mutating func insert(_ element: Element) {
        dict[element.id] = element
    }

    func contains(_ element: Element) -> Bool {
        dict.keys.contains(element.id)
    }
}

extension Table {
    mutating func insert(_ elements: any Sequence<Element> = []) {
        elements.forEach { insert($0) }
    }
}
