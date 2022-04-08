//
//  FriendlyManager.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import Foundation

final public class FriendlyManager: ObservableObject {
    public static let shared = FriendlyManager()

    public func removeScope(_ id: String) {
        PositionManager.shared.removePosition(id)
        if PositionManager.shared.on == id {
            PositionManager.shared.on = nil
        }
    }

    @Published var showPopText = false
}
