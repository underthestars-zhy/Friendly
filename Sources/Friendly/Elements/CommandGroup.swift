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
            MotionManager.shared.resetCenter()
            EyeTraceStorage.shared.showCommand = false
        }

        self.items = [defaultItem] + items()
    }
}
