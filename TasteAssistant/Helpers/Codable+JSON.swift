//
//  Codable+JSON.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 04.12.2022.
//

import Foundation

private let jsonWriteEncoder = JSONEncoder()

extension Encodable {
    func write(to fileURL: URL) throws {
        try jsonWriteEncoder.encode(self).write(to: fileURL)
    }
}

private let jsonReadDecoder = JSONDecoder()

extension Decodable {
    init(from fileURL: URL) throws {
        let data = try Data(contentsOf: fileURL)
        self = try jsonReadDecoder.decode(Self.self, from: data)
    }
}
