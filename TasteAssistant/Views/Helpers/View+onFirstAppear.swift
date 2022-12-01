//
//  View+onFirstAppear.swift
//  TasteAssistant
//
//  Created by Ernest Babayan on 02.12.2022.
//

import SwiftUI

extension View {
    func onFirstAppear(_ perform: @escaping () -> Void) -> some View {
        modifier(FirstAppearViewModifier(perform: perform))
    }
}

private struct FirstAppearViewModifier: ViewModifier {
    @State var didAppear = false
    let perform: () -> Void

    func body(content: Content) -> some View {
        content.onAppear {
            guard !didAppear else { return }
            didAppear = true

            perform()
        }
    }
}
