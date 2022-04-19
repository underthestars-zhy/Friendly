//
//  FriendlyPreferenceView.swift
//  
//
//  Created by 朱浩宇 on 2022/4/18.
//

import SwiftUI
import SwiftUIX

public struct FriendlyPreferenceView: View {
    @StateObject var friendlyManager: FriendlyManager
    @StateObject var sheetManager = SheetManager.shared

    public init() {
        _friendlyManager = StateObject(wrappedValue: FriendlyManager.shared)
    }

    @State var hideEx = true

    public var body: some View {
        ZStack {
            FriendlyScope(eternalId: "FriendlyPreferenceView Sheet Dismiss") {
                if !SheetManager.shared.view.isEmpty {
                    SheetManager.shared.view.removeLast()
                }
            }
            .priority(Int.min + 4 + (sheetManager.view.firstIndex(where: {
                $0.name == "FriendlyPreferenceView Sheet Dismiss"
            }) ?? 0))
            .hideExclusion(!hideEx)

            VStack {
                Row("Base movement speed") {
                    FriendlyButton("Base movement speed - Button") {
                        FriendlySheet {
                            NumberPadView(max: 3) { speed in
                                if let speed = Int(speed) {
                                    friendlyManager.baseSpeed = speed
                                    print(friendlyManager.baseSpeed)
                                }
                            }
                            .onAppear { hideEx = false }
                            .onDisappear { hideEx = true }
                        }.present("Base movement speed - Sheet")
                    } label: {
                        Text(String(friendlyManager.baseSpeed))
                    }
                    .hideExclusion(hideEx)
                }

                Row("Lateral first order acceleration") {
                    FriendlyButton("Lateral first order acceleration - Button") {
                        FriendlySheet {
                            NumberPadView(max: 3) { speed in
                                if let speed = Int(speed) {
                                    friendlyManager.hAcceleration = speed
                                }
                            }
                            .onAppear { hideEx = false }
                            .onDisappear { hideEx = true }
                        }.present("Lateral first order acceleration - Sheet")
                    } label: {
                        Text("\(friendlyManager.hAcceleration) %")
                    }
                    .hideExclusion(hideEx)
                }

                Row("Lateral secondary acceleration") {
                    FriendlyButton("Lateral secondary acceleration - Button") {
                        FriendlySheet {
                            NumberPadView(max: 3) { speed in
                                if let speed = Int(speed) {
                                    friendlyManager.h2Acceleration = speed
                                }
                            }
                            .onAppear { hideEx = false }
                            .onDisappear { hideEx = true }
                        }.present("Lateral secondary acceleration - Sheet")
                    } label: {
                        Text("\(friendlyManager.h2Acceleration) %")
                    }
                    .hideExclusion(hideEx)
                }

                Row("Longitudinal acceleration") {
                    FriendlyButton("Longitudinal acceleration - Button") {
                        FriendlySheet {
                            NumberPadView(max: 3) { speed in
                                if let speed = Int(speed) {
                                    friendlyManager.lAcceleration = speed
                                }
                            }
                            .onAppear { hideEx = false }
                            .onDisappear { hideEx = true }
                        }.present("Longitudinal acceleration - Sheet")
                    } label: {
                        Text("\(friendlyManager.lAcceleration) %")
                    }
                    .hideExclusion(hideEx)
                }

                Row("Speed when on button") {
                    FriendlyButton("Speed when on button - Button") {
                        FriendlySheet {
                            NumberPadView(max: 3) { speed in
                                if let speed = Int(speed) {
                                    friendlyManager.buttonSpeed = speed
                                }
                            }
                            .onAppear { hideEx = false }
                            .onDisappear { hideEx = true }
                        }.present("Speed when on button - Sheet")
                    } label: {
                        Text("\(friendlyManager.buttonSpeed)")
                    }
                    .hideExclusion(hideEx)
                }

                Row("Speed when on textfield") {
                    FriendlyButton("Speed when on textfield - Button") {
                        FriendlySheet {
                            NumberPadView(max: 3) { speed in
                                if let speed = Int(speed) {
                                    friendlyManager.tfSpeed = speed
                                }
                            }
                            .onAppear { hideEx = false }
                            .onDisappear { hideEx = true }
                        }.present("Speed when on textfield - Sheet")
                    } label: {
                        Text("\(friendlyManager.tfSpeed)")
                    }
                    .hideExclusion(hideEx)
                }
            }
        }
        .frame(width: 541 / 918 * Screen.main.width, height: 573 / 641 * Screen.main.height)
    }

    struct Row<Content>: View where Content: View {
        let text: String
        let content: Content

        init(_ text: String, @ViewBuilder content: () -> Content) {
            self.text = text
            self.content = content()
        }

        var body: some View {
            HStack {
                Text(text)
                Spacer()
                content
            }
            .padding(.horizontal)
            .padding()
        }
    }
}
