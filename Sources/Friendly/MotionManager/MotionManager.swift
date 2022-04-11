//
//  MotionManager.swift
//  
//
//  Created by 朱浩宇 on 2022/3/24.
//

import SwiftUI
import CoreMotion
import SwiftUIX

class MotionManager: NSObject, ObservableObject, CMHeadphoneMotionManagerDelegate {
    public static let shared = MotionManager()

    private var motionManager = CMHeadphoneMotionManager()

    var lastX = 0.0
    var lastY = 0.0

    var x = 0.0
    var y = 0.0

    var first = true

    var last: State = .center

    @Published var center = UnitPoint.center

    var needWait = false

    override init() {
        super.init()

        motionManager.delegate = self

        if !motionManager.isDeviceMotionAvailable {
            Task {
                await DeviceState.shared.notSupport()
            }
        }

        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] motion, error in
            guard let self = self, let motion = motion else { return }
            if self.first {
                self.first = false
                return
            }

            self.lastX = self.x
            self.lastY = self.y

            self.x = motion.attitude.roll
            self.y = motion.attitude.pitch
        }

        startMonitor()
    }

    public func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        Task {
            if motionManager.isDeviceMotionAvailable {
                await DeviceState.shared.connect()
            } else {
                await DeviceState.shared.notSupport()
            }
        }
    }

    public func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        Task {
            if motionManager.isDeviceMotionAvailable {
                await DeviceState.shared.disconnect()
            } else {
                await DeviceState.shared.notSupport()
            }
        }
    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
    }

    private func startMonitor() {
        Task(priority: .high) {
            while true {
                try? await Task.sleep(seconds: 1 / 60)
                if needWait {
                    try? await Task.sleep(seconds: 1.5)
                    resetData()
                    needWait = false
                }
                await updateCenter()
            }
        }
    }

    @MainActor private func calculate() async {
        var xOffest = await offsetCalculate(x, last: lastX, screen: Screen.main.width)
        var yOffset = await offsetCalculate(y, last: lastY, screen: Screen.main.height)

        let _last = last

        last = checkState(xOffest: xOffest, yOffset: yOffset)

        if _last == last {
            switch last {
            case .left, .right:
                xOffest *= 1.1
            case .down, .up:
                yOffset *= 1.1
            case .center: break
            }
        }

        if center.x + xOffest < 0 {
            center.x = 0
        } else if center.x + xOffest > 1 {
            center.x = 1
        } else {
            center.x += xOffest
        }

        if center.y + yOffset < 0 {
            center.y = 0
        } else if center.y + yOffset > 1 {
            center.y = 1
        } else {
            center.y += yOffset
        }

        CursorState.shared.check()
    }

    func offsetCalculate(_ current: Double, last: Double, screen: Double) async -> Double {
        var offset: Double = await DeviceState.shared.state == .connect ? current - last : 0

        offset = -offset

        if abs(offset) < 0.001 {
            offset = 0
        }

        switch CursorState.shared.state {
        case .circle:
            offset *= 700
        case .react:
            offset *= 100
        }

        offset = offset / screen

        offset = offset.rounded(toPlaces: 4)

        return offset
    }

    @MainActor private func updateCenter() async {
        await calculate()
    }

    func resetCenter() {
        center = .center
    }

    func reset() {
        needWait = true
    }

    func resetData() {
        lastX = 0.0
        lastY = 0.0

        x = 0.0
        y = 0.0

        first = true

        center = UnitPoint.center
        last = .center
    }

    enum State {
        case center
        case up
        case down
        case left
        case right
    }

    func checkState(xOffest: Double, yOffset: Double) -> State {
        if abs(yOffset) > abs(xOffest) {
            if yOffset > 0 {
                return .up
            } else {
                return .down
            }
        } else if abs(yOffset) < abs(xOffest) {
            if xOffest > 0 {
                return .right
            } else {
                return .left
            }
        } else {
            return .center
        }
    }
}
