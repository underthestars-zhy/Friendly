//
//  MotionManager.swift
//  
//
//  Created by 朱浩宇 on 2022/3/24.
//

import SwiftUI
import CoreMotion
import SwiftUIX

public class MotionManager: NSObject, ObservableObject, CMHeadphoneMotionManagerDelegate {
    public static let shared = MotionManager()

    private var motionManager = CMHeadphoneMotionManager()

    var lastX = 0.0
    var lastY = 0.0

    var x = 0.0
    var y = 0.0

    var first = true

    var last: State = .center
    var last2: State = .center

    var hasValue = false

    @Published var center = UnitPoint.center

    var needWait = false

    @Published var stopUI = false
    
    override init() {
        super.init()

        motionManager.delegate = self

        if !motionManager.isDeviceMotionAvailable {
            DeviceState.shared.notSupport()
        }

        start()

        startMonitor()
    }

    public func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        Task {
            if motionManager.isDeviceMotionAvailable {
                DeviceState.shared.connect()
            } else {
                DeviceState.shared.notSupport()
            }
        }
    }

    public func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        Task {
            if motionManager.isDeviceMotionAvailable {
                DeviceState.shared.disconnect()
            } else {
                DeviceState.shared.notSupport()
            }
        }
    }

    public func start() {
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] motion, error in
            guard let self = self, let motion = motion else { return }
            self.hasValue = true
            if self.first {
                self.first = false
                return
            }

            self.lastX = self.x
            self.lastY = self.y

            self.x = motion.attitude.roll
            self.y = motion.attitude.pitch
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
                    needWait = false
                    first = true
                    try? await Task.sleep(seconds: 1)
                    resetData()
                }

                if !stopUI {
                    await updateCenter()
                }

                do {
                    try Task.checkCancellation()
                } catch {
                    return
                }
            }
        }
    }

    private func calculate() {
        var xOffest = offsetCalculate(x, last: lastX, screen: Screen.main.width)
        var yOffset = offsetCalculate(y, last: lastY, screen: Screen.main.height)

        let _last = last
        let _last2 = last2

        last2 = last
        last = checkState(xOffest: xOffest, yOffset: yOffset)

        if _last == last {
            switch last {
            case .left, .right:
                if _last2 == .left || _last2 == .right {
                    xOffest *= Double(FriendlyManager.shared.h2Acceleration) / 100
                } else {
                    xOffest *= Double(FriendlyManager.shared.hAcceleration) / 100
                }
            case .down, .up:
                yOffset *= Double(FriendlyManager.shared.lAcceleration) / 100
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

    func offsetCalculate(_ current: Double, last: Double, screen: Double) -> Double {
        var offset: Double = DeviceState.shared.state == .connect ? current - last : 0

        offset = -offset

        if abs(offset) < 0.001 {
            offset = 0
        }

        switch CursorState.shared.state {
        case .circle:
            offset *= Double(FriendlyManager.shared.baseSpeed)
        case .react:
            offset *= Double(FriendlyManager.shared.buttonSpeed)
        case .textfield:
            offset *= Double(FriendlyManager.shared.tfSpeed)
        }

        offset = offset / screen

        offset = offset.rounded(toPlaces: 4)

        return offset
    }

    private func updateCenter() async {
        calculate()
    }

    func resetCenter() {
        center = .center
    }

    func reset() {
        needWait = true
    }

    func resetData() {
        center = UnitPoint.center
        last = .center
        last2 = .center
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
