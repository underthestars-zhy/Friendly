//
//  FriendlyStateButton.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

public struct FriendlyStateButton: View {
    @StateObject var devicesState: DeviceState

    public init() {
        _devicesState = StateObject(wrappedValue: DeviceState.shared)
    }

    public var body: some View {
        Image(systemName: getImage())
            .onTapGesture {

            }
    }

    func getImage() -> String {
        switch devicesState.state {
        case .connect:
            return "airpodspro"
        case .disconnect:
            return "airpodspro.chargingcase.wireless.fill"
        case .ignore:
            return "person.fill.questionmark"
        case .notSupport:
            return "xmark.octagon.fill"
        }
    }
}
