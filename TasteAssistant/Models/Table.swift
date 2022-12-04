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

    func element(for id: Element.ID) -> Element? {
        dict[id]
    }

    mutating func insert(_ element: Element) {
        dict[element.id] = element
    }

    @discardableResult
    mutating func remove(id elementId: Element.ID) -> Element? {
        let element = dict[elementId]

        dict.removeValue(forKey: elementId)

        return element
    }

    mutating func removeAll() {
        dict.removeAll()
    }

    func contains(_ element: Element) -> Bool {
        dict.keys.contains(element.id)
    }
}

extension Table {
    subscript(id elementId: Element.ID) -> Element? {
        dict[elementId]
    }

    mutating func insert(_ elements: any Sequence<Element> = []) {
        elements.forEach { insert($0) }
    }

    @discardableResult
    mutating func update(
        id elementId: Element.ID,
        _ transform: (inout Element) -> Void
    ) -> Element? {
        guard var element = self[id: elementId] else {
            return nil
        }

        transform(&element)
        self.insert(element)

        return element
    }
}
