//
//  FriendlyScope.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

public struct FriendlyScope: View, BeFriend {
    public let eternalId: String
    let onRight: () -> ()

    public var body: some View {
        FriendlyWrappedView(eternalId) {
            Color.clear
        }
        .onRight {
            onRight()
        }
        .onDisappear {
            FriendlyManager.shared.removeScope(eternalId)
        }
    }
}
