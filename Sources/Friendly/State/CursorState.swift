//
//  File.swift
//  
//
//  Created by 朱浩宇 on 2022/3/28.
//

import SwiftUI

class CursorState: ObservableObject {
    static let shared = CursorState()

    @Published var state: State = .circle

    enum State {
        case circle
        case react(cgRect: FRect)
    }

    var t: Task<Void, Never>?

    func check() {
        t?.cancel()
        t = Task {
            let positions = PositionManager.shared.positions

            var has = false

            for group in positions {
                let position = group.value
//                let eternalId = group.key

                if position.in() {
                    self.state = .react(cgRect: position.makeCursorRect())
                    has = true
                }
            }

            if !has {
                self.state = .circle
            }
        }
    }
}
