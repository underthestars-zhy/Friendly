//
//  PositionManager.swift
//  
//
//  Created by 朱浩宇 on 2022/4/6.
//

import SwiftUI

class PositionManager: ObservableObject {
    static let shared = PositionManager()

    var positions = [String : FPosition]()
    var on: String?

    var allIgnore = false
    var exclusion = Set<String>()

    func updatePosition(_ id: String, position: FPosition) {
        positions[id] = position
    }

    func removePosition(_ id: String) {
        positions.removeValue(forKey: id)
    }

    func exclusionCheck(_ id: String) -> Bool {
        exclusion.contains(id)
    }
}
