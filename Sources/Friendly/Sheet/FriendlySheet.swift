//
//  FriendlySheet.swift
//  
//
//  Created by 朱浩宇 on 2022/4/9.
//

import SwiftUI

struct FriendlySheet<Content> where Content: View {
    let content: Content

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    func present(_ name: String) {
        SheetManager.shared.name = name
        SheetManager.shared.view = AnyView(content)
    }
}
