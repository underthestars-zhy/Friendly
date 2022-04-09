//
//  FriendlySheet.swift
//  
//
//  Created by 朱浩宇 on 2022/4/9.
//

import SwiftUI

public struct FriendlySheet<Content> where Content: View {
    let content: Content

    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    public func present(_ name: String) {
        SheetManager.shared.view.append(.init(view: AnyView(content), name: name))
    }
}
