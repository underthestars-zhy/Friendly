//
//  Friendly+commandView.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

public extension Friendly {
    func commandView(_ commandGroup: () -> CommandGroup) -> Friendly {
        Storage.shared.commandGroup = commandGroup()
        return self
    }
}
