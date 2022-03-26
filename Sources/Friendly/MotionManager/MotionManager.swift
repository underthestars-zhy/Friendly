//
//  MotionManager.swift
//  
//
//  Created by 朱浩宇 on 2022/3/24.
//

import SwiftUI
import CoreMotion

public class MotionManager: NSObject, ObservableObject, CMHeadphoneMotionManagerDelegate {
    public static let shared = MotionManager()

    private var motionManager = CMHeadphoneMotionManager()

    var lastX = 0.0
    var lastY = 0.0

    var x = 0.0
    var y = 0.0

    var first = true

    @Published var center = UnitPoint.center

    override init() {
        super.init()

        motionManager.delegate = self

        if motionManager.isDeviceMotionAvailable {
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
        } else {
            print("Not support")
        }

        startMonitor()
    }

    public func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        first = true
        Task {
            await DeviceState.shared.connect()
        }
    }

    public func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        first = false
        Task {
            await DeviceState.shared.disconnect()
        }
    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
    }

    private func startMonitor() {
        Task(priority: .high) {
            while true {
                try? await Task.sleep(seconds: 1 / 60)
                await updateCenter()
            }
        }
    }

    @MainActor private func calculate() async {
        let xOffest = await offsetCalculate(x, last: lastX)
        let yOffset = await offsetCalculate(y, last: lastY)

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
    }

    func offsetCalculate(_ current: Double, last: Double) async -> Double {
        var offset: Double = await DeviceState.shared.state == .connect ? current - last : 0

        offset = -offset

        if abs(offset) < 0.001 {
            offset = 0
        }

        offset *= 2
        

        return offset
    }

    @MainActor private func updateCenter() async {
        await calculate()
    }
}

