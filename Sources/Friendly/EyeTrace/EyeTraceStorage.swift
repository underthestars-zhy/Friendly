//
//  EyeTraceStorage.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI
import SwiftDate

class EyeTraceStorage: ObservableObject {
    static let shared = EyeTraceStorage()

    var inProcress = false
    var process = [EyeTraceManager.State]()
    var processCheckState: EyeTraceManager.State?
    var processStartTime = Date()
    var canSet = true

    @Published var showCommand = falseI

    var lastStopTime = Date()

    func check() {
        guard let processCheckState = processCheckState else {
            return
        }

        if Date() - 1.seconds > processStartTime  {
            if percent(processCheckState) {
                switch processCheckState {
                case .none: break
                case .both:
                    showCommand.toggle()
                case .left: break
                case .right: break
                }
            }

            inProcress = false
            canSet = false
            lastStopTime = Date()
        }
    }

    func percent(_ item: EyeTraceManager.State) -> Bool {
        let all: Double = Double(process.count)
        let vaild: Double = process.reduce(into: 0.0) { partialResult, state in
            partialResult += state == item ? 1 : 0
        }

        return (vaild / all) > 0.8
    }

    func startProcess(_ state: EyeTraceManager.State) {
        guard canSet else { return }
        if Date() - (1 / 2).seconds > lastStopTime  {
            inProcress = true
            processCheckState = state
            process = []
            processStartTime = Date()
        }
    }
}
