//
//  CommandItem.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

public struct CommandItem: Identifiable {
    public var id: String {
        name
    }
    
    let name: String
    let image: Image
    let onTap: () -> ()
}
