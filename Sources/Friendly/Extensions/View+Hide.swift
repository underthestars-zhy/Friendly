//
//  File.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

extension View where Self: BeFriend {
    func hide(_ when: Bool) -> FriendlyWrappedView<Self.Body> {
        if when {
            PositionManager.shared.hide.insert(self.eternalId)
        } else {
            PositionManager.shared.hide.remove(self.eternalId)
        }

        return FriendlyWrappedView(eternalId) {
            self.body
        }
    }
}
