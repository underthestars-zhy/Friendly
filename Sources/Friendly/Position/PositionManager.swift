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

    func updatePosition(_ id: UUID, position: FPosition) {
        positions[id.uuidString] = position
    }
}
