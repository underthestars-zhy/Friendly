//
//  FPosition.swift
//  
//
//  Created by 朱浩宇 on 2022/4/6.
//

import SwiftUI
import SwiftUIX

struct FPosition {
    let x: Double
    let y: Double

    let width: Double
    let height: Double

    init(x: Double, y: Double, width: Double, height: Double) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    init(cgRect: CGRect) {
        self.x = cgRect.minX
        self.y = cgRect.minY
        self.width = cgRect.width
        self.height = cgRect.height
    }

    func `in`() -> Bool {
        let center = MotionManager.shared.center
        let x = Screen.main.width * center.x
        let y = Screen.main.height * center.y

        let frameXStart = self.x - 2
        let frameYStart = self.y - 2
        let frameXEnd = self.x + self.width + 2
        let frameYEnd = self.y + self.height + 2

        return x > frameXStart && x < frameXEnd && y > frameYStart && y < frameYEnd
    }

    func makeCursorRect() -> FRect {
        let x = self.x + width / 2
        let y = self.y + height / 2

        let width = width + 10
        let height = height + 10

        return .init(x: x, y: y, width: width, height: height)
    }

    func makeTextFiledsRect() -> FRect {
        let x = self.x - 2
        let y = self.y + height / 2

        let width = 5.0
        let height = height + 5

        return .init(x: x, y: y, width: width, height: height)
    }
}
