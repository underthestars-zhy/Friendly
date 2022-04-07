//
//  EyeTraceView.swift
//  
//
//  Created by 朱浩宇 on 2022/4/7.
//

import SwiftUI
import ARKit

struct EyeTraceView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARSCNView {
        EyeTraceManager.shared.sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {

    }

    typealias UIViewType = ARSCNView
}
