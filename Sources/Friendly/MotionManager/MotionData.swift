//
//  File.swift
//  
//
//  Created by 朱浩宇 on 2022/4/15.
//

import Foundation

struct MotionData {
    var data: Double? = nil

    mutating func insert(_ item: Double) {
        data = item
    }

    func repeated(_ item: Double) -> Bool {
        data == item
    }
}
