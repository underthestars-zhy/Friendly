//
//  View+Postion.swift
//  
//
//  Created by 朱浩宇 on 2022/3/26.
//

import SwiftUI

struct PositionModifier: View {
    @Binding var postion: CGRect

    var body: some View {
        return GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                postion = geometry.frame(in: CoordinateSpace.local)
            }

            return Color.clear
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
