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
    let ignore: Bool

    public let eternalId: String

    public init(_ id: String, ignore: Bool = false, action: @escaping (() -> Void), label: @escaping (() -> Content)) {
        self.action = action
        self.content = label()
        self.eternalId = id
        self.ignore = ignore
    }

    public var body: some View {
        FriendlyWrappedView(eternalId, ignore: ignore) {
            Button {
                action()
            } label: {
                content
            }
        }
        .onRight {
            if positionManager.on == eternalId {
                TapMusic.playSounds()
                action()
            }
        }
        .contentShape(Rectangle())
        .onAppear {
            positionManager.buttons.insert(eternalId)
        }
//        .task {
//            if ignore {
//                try? await Task.sleep(nanoseconds: NSEC_PER_MSEC)
//                positionManager.buttons.insert(eternalId)
//            }
//        }
    }
}
