//
//  View+Postion.swift
//  
//
//  Created by 朱浩宇 on 2022/3/26.
//

import SwiftUI

struct PositionModifier: View {
    @Binding var postion: CGRect
    @State var appear = true

    var body: some View {
        return GeometryReader { geometry in
            Color.clear
                .onAppear {
                    DispatchQueue.main.async {
                        postion = geometry.frame(in: CoordinateSpace.global)
                    }
                }
                .onChange(of: geometry.frame(in: CoordinateSpace.global)) { _ in
                    if appear && !FriendlyManager.shared.stop && DeviceState.shared.state == .connect {
                        postion = geometry.frame(in: CoordinateSpace.global)
                    }
                }
                .onDisappear {
                    appear = false
                }
        }
    }
}

extension View {
    func getPosition(_ postion: Binding<CGRect>) -> some View {
        self
            .background(
                PositionModifier(postion: postion)
            )
    }
}
