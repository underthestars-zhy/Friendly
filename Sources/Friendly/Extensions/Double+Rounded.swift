//
//  Double+Rounded.swift
//  
//
//  Created by 朱浩宇 on 2022/3/26.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
