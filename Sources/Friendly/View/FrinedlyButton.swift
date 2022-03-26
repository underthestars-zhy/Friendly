//
//  FrinedlyButton.swift
//  
//
//  Created by 朱浩宇 on 2022/3/26.
//

import SwiftUI

struct FrinedlyButton<Content: View>: View {
    @StateObject var devicesState: DeviceState
    
    let action: (() -> Void)
    let content: Content

    public init(action: @escaping (() -> Void), lable: @escaping (() -> Content)) {
        self.action = action
        self.content = lable()

        _devicesState = StateObject(wrappedValue: DeviceState.shared)
    }

    public var body: some View {
        Button {
            action()
        } label: {
            content
        }
    }
}
