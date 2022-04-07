//
//  RectCursorView.swift
//  
//
//  Created by 朱浩宇 on 2022/4/6.
//

import SwiftUI

struct RectCursorView: View {
    @Environment(\.colorScheme) var colorScheme
    let rect: FRect

    var body: some View {
        Group {
            switch colorScheme {
            case .light:
                Rectangle()
                    .foregroundColor(Color(hexadecimal: "2C2C2E").opacity(0.41))

            case .dark:
                Rectangle()
                    .foregroundColor(Color(hexadecimal: "FFFFFF").opacity(0.51))
            @unknown default:
                Text("Error")
            }
        }
        .frame(width: rect.width, height: rect.height)
        .cornerRadius(6)
        .position(x: rect.x, y: rect.y)
        .opacity(0.5)
    }
}
