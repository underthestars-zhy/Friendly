//
//  SheetManager.swift
//  
//
//  Created by 朱浩宇 on 2022/4/9.
//

import SwiftUI

class SheetManager: ObservableObject {
    static let shared = SheetManager()

    @Published var view: [Item] = []

    struct Item: Identifiable {
        var id: String {
            name
        }
        let view: AnyView
        let name: String
    }
}
