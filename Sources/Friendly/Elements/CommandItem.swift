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

    public init(name: String, image: Image, onTap: @escaping () -> ()) {
        self.name = name
        self.image = image
        self.onTap = onTap
    }
}
