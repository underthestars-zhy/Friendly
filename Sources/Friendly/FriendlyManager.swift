//
//  FriendlyManager.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import Foundation

final class FriendlyManager: ObservableObject {
    static let shared = FriendlyManager()

    func removeScope(_ id: String) {
        PositionManager.shared.removePosition(id)
        PositionManager.shared.buttons.remove(id)
        if PositionManager.shared.on == id {
            PositionManager.shared.on = nil
        }
    }
}
