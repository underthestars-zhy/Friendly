//
//  DeviceState.swift
//  
//
//  Created by 朱浩宇 on 2022/3/24.
//

import Foundation

@MainActor
class DeviceState: ObservableObject, Sendable {
    enum State {
        case connect
        case disconnect
        case ignore
        case prepare
        case notSupport
    }

    static let shared = DeviceState()

    @Published var state: State = .disconnect

    func disconnect() {
        self.state = .disconnect
#if DEBUG
        print("disconnect")
#endif
    }

    func connect() async {
        self.state = .prepare
        try? await Task.sleep(seconds: 2)
        self.state = .connect
#if DEBUG
        print("connect")
#endif
    }

    func ignore() {
        self.state = .ignore
#if DEBUG
        print("ignore")
#endif
    }

    func notSupport() {
        self.state = .notSupport
#if DEBUG
        print("Not support")
#endif
    }
}
