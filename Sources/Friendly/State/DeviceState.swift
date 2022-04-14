//
//  DeviceState.swift
//  
//
//  Created by 朱浩宇 on 2022/3/24.
//

import Foundation

public class DeviceState: ObservableObject {
    public enum State {
        case connect
        case disconnect
        case ignore
        case notSupport
    }

    public static let shared = DeviceState()

    @Published public var state: State = .disconnect

    func disconnect() {
        self.state = .disconnect
#if DEBUG
        print("disconnect")
#endif
    }

    func connect() {
        if !(self.state == .notSupport) {
            self.state = .connect
        }
#if DEBUG
        print("connect")
#endif
    }

    func ignore() {
        if !(self.state == .notSupport) {
            self.state = .ignore
        }
#if DEBUG
        print("ignore")
#endif
    }

    func notSupport() {
        if !(self.state == .notSupport) {
            self.state = .notSupport
        }
#if DEBUG
        print("Not support")
#endif
    }
}
