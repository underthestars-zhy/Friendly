//
//  CommandItemBuilder.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

@resultBuilder public struct CommandItemBuilder {
    public static func buildBlock(_ components: CommandItem...) -> [CommandItem] {
        return components
    }
}
