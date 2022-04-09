//
//  FriendlyWrappedView.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

public struct FriendlyWrappedView<Content>: View, BeFriend where Content: View {
    @StateObject var positionManager = PositionManager.shared
    @State var position: CGRect = .init()
    
    let eternalId: String
    let content: Content

    public init(_ id: String, @ViewBuilder content: () -> Content) {
        eternalId = id
        self.content = content()
    }

    public var body: some View {
        _FriendlyWrappedView(eternalId) {
            content
                .getPosition($position)
                .onChange(of: position) { newValue in
                    positionManager.updatePosition(eternalId, position: .init(cgRect: position))
                }
        }
    }
}

struct _FriendlyWrappedView<Content>: View, BeFriend where Content: View {
    let eternalId: String
    let content: Content

    public init(_ id: String, @ViewBuilder content: () -> Content) {
        eternalId = id
        self.content = content()
    }

    public var body: some View {
        content
    }
}
