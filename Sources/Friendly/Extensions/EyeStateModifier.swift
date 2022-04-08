//
//  EyeStateModifier.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

struct EyeStateModifier: ViewModifier {
    @StateObject var eyeTraceManager = EyeTraceManager.shared
    let state: EyeTraceManager.State
    let action: () -> ()

    func body(content: Content) -> some View {
        content
            .onChange(of: eyeTraceManager.eyeState) { eye in
                if eye == state {
                    action()
                }
            }
    }
}
