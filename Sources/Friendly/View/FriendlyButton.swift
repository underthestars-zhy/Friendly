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
    
    let action: (() -> Void)
    let content: Content

    @State var position: CGRect = .init()

    let eternalId: String

    public init(_ id: String, action: @escaping (() -> Void), lable: @escaping (() -> Content)) {
        self.action = action
        self.content = lable()
        self.eternalId = id
    }

    public var body: some View {
        Button {
            action()
        } label: {
            content
        }
        .getPosition($position)
        .onChange(of: position) { newValue in
            positionManager.updatePosition(eternalId, position: .init(cgRect: position))
        }
        .onDisappear {
            FriendlyManager.shared.removeScope(eternalId)
        }
        .onRight {
            if positionManager.on == eternalId {
                action()
            }
        }
    }
}
