//
//  NumberPadView.swift
//  
//
//  Created by 朱浩宇 on 2022/4/9.
//

import SwiftUI

struct NumberPadView: View {
    let max: Int

    @State var texts = [String]()

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<max, id: \.self) { id in
                    VStack {
                        Text(getText(id))
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 10, height: 2)
                    }
                    .padding()
                }
            }

            Spacer()
        }
        .frame(width: 350, height: 400)
    }

    func getText(_ id: Int) -> String {
        if texts.count > id {
            return texts[id]
        } else {
            return ""
        }
    }
}
