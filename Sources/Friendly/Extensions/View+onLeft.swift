//
//  View+onLeft.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

extension View {
    func onLeft(_ action: @escaping () -> ()) -> some View {
        self
            .modifier(EyeStateModifier(state: .left, action: action))
    }
}
