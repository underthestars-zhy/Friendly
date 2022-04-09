//
//  SheetView.swift
//  
//
//  Created by 朱浩宇 on 2022/4/9.
//

import SwiftUI
import SwiftUIX

struct SheetView<Content>: View, BeFriend where Content: View {
    @Environment(\.colorScheme) var colorScheme

    let eternalId: String
    let content: Content

    init(_ id: String, @ViewBuilder _ content: () -> Content) {
        self.eternalId = id
        self.content = content()
    }

    var body: some View {
        content
            .background(UITraitCollection.current.userInterfaceStyle == .light ? Color(hexadecimal: "F2F2F6") : Color(hexadecimal: "1C1B1D"))
            .cornerRadius(10)
            .shadow(color: colorScheme == .light ? .black.opacity(0.3) : .clear, radius: 30, x: 0, y: 0)
    }
}
