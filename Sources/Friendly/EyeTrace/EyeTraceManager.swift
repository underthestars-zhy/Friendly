//
//  EyeTraceManager.swift
//  
//
//  Created by 朱浩宇 on 2022/3/28.
//

import SwiftUI
import ARKit

class EyeTraceManager: NSObject, ARSCNViewDelegate, ObservableObject {
    static let shared = EyeTraceManager()

    let sceneView: ARSCNView = .init()
    let configuration = ARFaceTrackingConfiguration()

    @Published var eyeState: State = .none

    override init() {
        super.init()

        configuration.maximumNumberOfTrackedFaces = 1

        self.sceneView.delegate = self

        guard ARFaceTrackingConfiguration.isSupported else {
            return
        }
    }

    func start() {
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    func stop() {
        sceneView.session.pause()
    }

    enum State {
        case right
        case left
        case both
        case none
    }
}

extension EyeTraceManager {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARFaceAnchor else { return }
        let right = anchor.blendShapes[.eyeBlinkLeft]!.doubleValue < 0.1
        let left = anchor.blendShapes[.eyeBlinkRight]!.doubleValue < 0.1

        if right && left {
            eyeState = .none
        } else if right {
            eyeState = .right
        } else if left {
            eyeState = .left
        } else {
            eyeState = .both
        }

        print(eyeState)
    }
}
