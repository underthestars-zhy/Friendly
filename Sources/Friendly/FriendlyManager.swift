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
        PositionManager.shared.hideExclusion.remove(id)
        PositionManager.shared.hide.remove(id)
        if PositionManager.shared.on == id {
            PositionManager.shared.on = nil
        }
    }

    @Published public var stop = false
    @Published public var setCursor = false

    public func refreshCursorData() {
        baseSpeed = 700
        hAcceleration = 120
        h2Acceleration = 150
        lAcceleration = 110
        buttonSpeed = 350
        tfSpeed = 300
    }

    @Published var baseSpeed = 700
    @Published var hAcceleration = 120
    @Published var h2Acceleration = 150
    @Published var lAcceleration = 110
    @Published var buttonSpeed = 350
    @Published var tfSpeed = 300
}
