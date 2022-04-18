//
//  View+HideExclusion.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

public extension View where Self: BeFriend {
    func hideExclusion(_ when: Bool) -> FriendlyWrappedView<Self.Body> {
        if when {
            PositionManager.shared.hideExclusion.insert(self.eternalId)
        } else {
            print(eternalId)
            PositionManager.shared.hideExclusion.remove(self.eternalId)
        }

        return FriendlyWrappedView(eternalId) {
            self.body
        }
    }
}
