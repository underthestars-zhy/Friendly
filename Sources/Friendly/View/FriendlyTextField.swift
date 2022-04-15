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

    @Binding var shouldSpeech: Bool

    public init(_ id: String, _ title: String, text: Binding<String>, focused: FocusState<Bool>, shouldSpeech: Binding<Bool>) {
        self.eternalId = id
        self.title = title
        self._text = text
        self._focused = focused
        _positionManager = StateObject(wrappedValue: PositionManager.shared)
        _shouldSpeech = shouldSpeech
    }

    public var body: some View {
        FriendlyWrappedView(eternalId) {
            TextField(title, text: $text)
                .ignoresSafeArea(.keyboard)
                .focused($focused)
        }
        .onRight {
            shouldSpeech.toggle()
        }
        .onChange(of: focused) { _ in
            SpeechManager.shared.stopRecord()
            SpeechManager.shared.onRecord = ""
        }
        .onChange(of: positionManager.focus) { newValue in
            if newValue != eternalId {
                focused = false
            }
        }
    }
}
