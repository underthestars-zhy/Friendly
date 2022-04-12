//
//  FriendlyWrappedView.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

public struct FriendlyWrappedView<Content>: View, BeFriend where Content: View {
    @StateObject var sheetManager = SheetManager.shared
    
    public let eternalId: String
    let content: Content
    let ignore: Bool

    public init(_ id: String, ignore: Bool = false, @ViewBuilder content: () -> Content) {
        eternalId = id
        self.content = content()
        self.ignore = ignore
    }

    public var body: some View {
        _FriendlyWrappedView(eternalId, ignore: ignore) {
            content
        }
        .hide(!sheetManager.view.isEmpty)
    }
}

struct _FriendlyWrappedView<Content>: View, BeFriend where Content: View {
    @StateObject var positionManager = PositionManager.shared
    @State var position: CGRect = .init()

    let eternalId: String
    let content: Content
    let ignore: Bool

    public init(_ id: String, ignore: Bool = false, @ViewBuilder content: () -> Content) {
        eternalId = id
        self.content = content()
        self.ignore = ignore
    }

    public var body: some View {
        content
            .getPosition($position)
            .onChange(of: position) { newValue in
                positionManager.updatePosition(eternalId, position: .init(cgRect: position))
            }
            .task {
                if ignore {
                    try? await Task.sleep(nanoseconds: NSEC_PER_MSEC)
                    positionManager.updatePosition(eternalId, position: .init(cgRect: position))
                }
            }
            .onDisappear {
                FriendlyManager.shared.removeScope(eternalId)

            }
    }
}
