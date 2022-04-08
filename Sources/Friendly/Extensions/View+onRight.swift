//
//  View+onRight.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

extension BeFriend where Self: View {
    func onRight(_ action: @escaping () -> ()) -> some View {
        self
            .modifier(EyeStateModifier(state: .right, eternalId: eternalId, action: action))
    }
}
