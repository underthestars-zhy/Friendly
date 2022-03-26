//
//  Task+Seconds.swift
//  
//
//  Created by 朱浩宇 on 2022/3/24.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
