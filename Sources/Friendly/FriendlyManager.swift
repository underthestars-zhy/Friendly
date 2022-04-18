//
//  FriendlyManager.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import Foundation

final public class FriendlyManager: ObservableObject {
    public static let shared = FriendlyManager()

    func removeScope(_ id: String) {
        PositionManager.shared.removePosition(id)
        PositionManager.shared.buttons.remove(id)
        PositionManager.shared.textfileds.remove(id)
        if PositionManager.shared.on == id {
            PositionManager.shared.on = nil
        }
    }

    @Published public var stop = false
    @Published public var setCursor = false
}
