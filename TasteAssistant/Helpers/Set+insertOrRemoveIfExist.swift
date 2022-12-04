//
//  Set+insertOrRemoveIfExist.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 01.12.2022.
//

import Foundation

extension Set {
    mutating func insertOrRemoveIfExist(_ member: Element) {
        if contains(member) {
            remove(member)
        } else {
            insert(member)
        }
    }
}
