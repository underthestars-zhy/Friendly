//
//  CommandView.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI
import SwiftUIX

struct CommandView: View {
    @StateObject var storage = Storage.shared
    @StateObject var eyeTraceManger = EyeTraceManager.shared

    var body: some View {
        HStack {
            ForEach(storage.commandGroup?.items ?? []) { commandItem in
                FriendlyButton("CommandDefault") {
                    commandItem.onTap()
                } lable: {
                    VStack {
                        commandItem.image
                            .font(.largeTitle)
                            .foregroundColor(Color.label)
                        Text(commandItem.name)
                            .font(.title3)
                            .padding(.top)
                            .foregroundColor(Color.label)
                    }
                }
                .exclusion()
                .padding()
            }
        }
        .padding()
        .background(VisualEffectBlurView(blurStyle: .prominent).cornerRadius(20))
        .onAppear {
            PositionManager.shared.exclusion = []
            PositionManager.shared.allIgnore = true
        }
        .onDisappear {
            PositionManager.shared.allIgnore = false
        }
    }
}
