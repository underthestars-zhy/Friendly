//
//  File.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

public struct CommandGroup {
    let items: [CommandItem]

    public init(@CommandItemBuilder _ items: () -> [CommandItem]) {
        let defaultItem = CommandItem(name: "Reset Cursor", image: Image(systemName: "dot.circle.and.cursorarrow")) {
            FriendlyManager.shared.setCursor = true
            EyeTraceStorage.shared.showCommand = false
            print("do")
        }

        self.items = [defaultItem] + items()
    }
}
