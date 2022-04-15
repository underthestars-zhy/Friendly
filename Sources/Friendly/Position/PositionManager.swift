//
//  PositionManager.swift
//  
//
//  Created by 朱浩宇 on 2022/4/6.
//

import SwiftUI

public class PositionManager: ObservableObject {
    public static let shared = PositionManager()

    @Published var focus: String?

    var positions = [String : FPosition]()
    var on: String?

    var allIgnore = false
    var exclusion = Set<String>()

    public var buttons = Set<String>()

    var textfileds = Set<String>()

    var hide = Set<String>()

    var hideExclusion = Set<String>()

    var priority = [String : Int]()

    func updatePosition(_ id: String, position: FPosition) {
        positions[id] = position
    }

    func removePosition(_ id: String) {
        positions.removeValue(forKey: id)
    }

    func exclusionCheck(_ id: String) -> Bool {
        exclusion.contains(id)
    }

    public func reset() {
        positions = [:]
        on = nil
        allIgnore = false
        exclusion = []
        buttons = []
        hide = []
        hideExclusion = []
        priority = [:]
    }
}
