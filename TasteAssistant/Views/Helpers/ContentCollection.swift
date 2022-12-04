//
//  ContentCollection.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 03.12.2022.
//

import SwiftUI

struct ContentCollection<Data: RandomAccessCollection, ID: Hashable, Content> {
    let data: Data
    let id: KeyPath<Data.Element, ID>
    @ViewBuilder var content: (Data.Element) -> Content
}

extension ContentCollection where Data.Element: Identifiable, ID == Data.Element.ID {
    init(
        _ data: Data,
        _ content: @escaping (Data.Element) -> Content
    ) {
        self.init(data: data, id: \.id, content: content)
    }
}

extension ForEach where Content: View {
    init(_ collection: ContentCollection<Data, ID, Content>) {
        self.init(
            collection.data,
            id: collection.id,
            content: collection.content
        )
    }
}

extension RandomAccessCollection {
    func map<ID: Hashable, Content>(
        id: KeyPath<Element, ID>,
        @ViewBuilder content: @escaping (Element) -> Content
    ) -> ContentCollection<Self, ID, Content> {
        ContentCollection(data: self, id: id, content: content)
    }

    func map<Content>(
        @ViewBuilder content: @escaping (Element) -> Content
    ) -> ContentCollection<Self, Element.ID, Content>
    where Element: Identifiable {
        ContentCollection(data: self, id: \.id, content: content)
    }
}
