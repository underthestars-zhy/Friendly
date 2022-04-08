//
//  Storage.swift
//  
//
//  Created by 朱浩宇 on 2022/4/8.
//

import SwiftUI

class Storage: ObservableObject {
    static let shared = Storage()

    var commandGroup: CommandGroup?
}
