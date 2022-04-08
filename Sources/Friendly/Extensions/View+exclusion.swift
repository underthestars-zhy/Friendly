//
//  View+exclusion.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

extension View where Self: BeFriend {
    func exclusion() -> Self {
        PositionManager.shared.exclusion.insert(self.eternalId)
        return self
    }
}
