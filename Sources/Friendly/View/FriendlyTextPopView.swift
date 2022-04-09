//
//  FriendlyTextPopView.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

struct FriendlyTextPopView: View {
    @Environment(\.colorScheme) var colorScheme

    let content: String

    var body: some View {
        Text(content)
            .padding()
            .background(.init(uiColor: .systemBackground))
            .cornerRadius(10)
            .shadow(color: (colorScheme == .light ? Color.black : .white).opacity(0.5), radius: 20, x: 0, y: 0)
    }
}
