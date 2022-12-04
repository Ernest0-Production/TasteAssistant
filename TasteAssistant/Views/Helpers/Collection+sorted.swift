//
//  Collection+sorted.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 03.12.2022.
//

import Foundation

extension Collection {
    func sorted<Value: Comparable>(
        order: SortOrder = .forward,
        by comparableValue: (Element) -> Value
    ) -> [Element] {
        sorted(by: { lhs, rhs in
            switch order {
            case .forward:
                return comparableValue(lhs) < comparableValue(rhs)
            case .reverse:
                return comparableValue(lhs) > comparableValue(rhs)
            }
        })
    }
}
