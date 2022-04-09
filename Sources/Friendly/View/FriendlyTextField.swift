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
    @Binding var text: String?

    @FocusState var focused: Bool

    @StateObject var speechManager = SpeechManager.shared
    @StateObject var positionManager = PositionManager.shared

    public init(_ id: String, _ title: String, text: Binding<String?>) {
        self.eternalId = id
        self.title = title
        self._text = text
    }

    public var body: some View {
        FriendlyWrappedView(eternalId) {
            TextField(title, text: $text)
                .focused($focused)
        }
        .onRight {
            focused.toggle()
        }
        .onChange(of: focused) { newValue in
            if focused {
                speechManager.startRecord()
                speechManager.onRecord = eternalId
            } else {
                speechManager.stopRecord()
                speechManager.onRecord = ""
            }
        }
        .onChange(of: speechManager.text) { _ in
            if speechManager.onRecord == eternalId {
                text = speechManager.lastText + speechManager.text
            }
        }
        .onChange(of: speechManager.lastText) { _ in
            if speechManager.onRecord == eternalId {
                text = speechManager.lastText + speechManager.text
            }
        }
        .onChange(of: positionManager.focus) { newValue in
            if newValue != eternalId {
                focused = false
            }
        }
    }
}
