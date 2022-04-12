//
//  FriendlyTextField.swift
//  
//
//  Created by 朱浩宇 on 2022/4/9.
//

import SwiftUI

public struct FriendlyTextField: View, BeFriend {
    public let eternalId: String
    let title: String
    @Binding var text: String

    @FocusState var focused: Bool

    @StateObject var positionManager: PositionManager

    @State var shouldSpeech = false

    public init(_ id: String, _ title: String, text: Binding<String>, focused: FocusState<Bool>) {
        self.eternalId = id
        self.title = title
        self._text = text
        self._focused = focused
        _positionManager = StateObject(wrappedValue: PositionManager.shared)
    }

    public var body: some View {
        FriendlyWrappedView(eternalId) {
            TextField(title, text: $text)
                .focused($focused)
        }
        .onRight {
            MotionManager.shared.stop()

            focused.toggle()

            DispatchQueue.main.async {
                MotionManager.shared.start()
            }

            if !focused {
                SpeechManager.shared.startRecord()
                SpeechManager.shared.onRecord = eternalId
            } else {
                SpeechManager.shared.stopRecord()
                SpeechManager.shared.onRecord = ""
            }
        }
        .onChange(of: focused) {
            if !$0 {
                SpeechManager.shared.stopRecord()
                SpeechManager.shared.onRecord = ""
            }
        }
        .onChange(of: positionManager.focus) { newValue in
            if newValue != eternalId {
                focused = false
            }
        }
    }
}
