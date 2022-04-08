//
//  FriendlyButton.swift
//  
//
//  Created by 朱浩宇 on 2022/3/26.
//

import SwiftUI
import SwiftUIX

public struct FriendlyButton<Content: View>: View, BeFriend {
    @StateObject var motionManager = MotionManager.shared
    @StateObject var positionManager = PositionManager.shared
    @StateObject var friendlyManager = FriendlyManager.shared
    
    let action: (() -> Void)
    let content: Content

    let eternalId: String

    public init(_ id: String, action: @escaping (() -> Void), lable: @escaping (() -> Content)) {
        self.action = action
        self.content = lable()
        self.eternalId = id
    }

    public var body: some View {
        FriendlyWrappedView(eternalId) {
            Button {
                action()
            } label: {
                content
            }
        }
        .hide(friendlyManager.showPopText)
        .onRight {
            if positionManager.on == eternalId {
                action()
            }
        }
        .onDisappear {
            FriendlyManager.shared.removeScope(eternalId)
        }
        .onAppear {
            positionManager.buttons.insert(eternalId)
        }
    }
}
