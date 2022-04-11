//
//  FriendlyDismiss.swift
//  
//
//  Created by 朱浩宇 on 2022/4/11.
//

import Foundation

public struct FriendlyDismiss {
    public func dismiss() {
        if !SheetManager.shared.view.isEmpty  {
            SheetManager.shared.view.removeLast()
        }
    }

    public init() {}
}
