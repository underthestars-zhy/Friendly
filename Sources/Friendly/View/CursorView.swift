//
//  CursorView.swift
//  
//
//  Created by 朱浩宇 on 2022/3/26.
//

import SwiftUI
import SwiftUIX

public struct CursorView: View {
    @Environment(\.colorScheme) var colorScheme

    public var body: some View {
        switch colorScheme {
        case .light:
            Circle()
                .foregroundColor(Color(hexadecimal: "2C2C2E").opacity(0.41))
                .frame(width: 20, height: 20)
        case .dark:
            Circle()
                .foregroundColor(Color(hexadecimal: "FFFFFF").opacity(0.51))
                .frame(width: 20, height: 20)
        @unknown default:
            Text("Error")
        }
    }

    public init() {}
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CursorView()

            Color.gray
        }
            .previewLayout(.sizeThatFits)
    }
}
