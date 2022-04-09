//
//  View+priority.swift
//  
//
//  Created by 朱浩宇 on 2022/4/9.
//

import SwiftUI

extension View where Self: BeFriend {
    func priority(_ priority: Int) -> FriendlyWrappedView<Self.Body> {
        PositionManager.shared.priority[eternalId] = priority

        return FriendlyWrappedView(eternalId) {
            self.body
        }
    }
}
