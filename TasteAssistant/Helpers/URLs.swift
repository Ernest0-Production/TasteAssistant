//
//  URLs.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 04.12.2022.
//

import Foundation

extension URL {
    static let documentsDirectory = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first!
}
