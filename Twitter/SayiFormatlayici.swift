//
//  SayiFormatlayici.swift
//  Twitter
//

import Foundation

extension Int {
    var abbreviated: String {
        let num = Double(self)
        
        let thousand = num / 1_000
        let million  = num / 1_000_000
        
        func format(_ value: Double) -> String {
            let s = String(format: "%.1f", value)
            return s.replacingOccurrences(of: ".0", with: "")
        }
        
        switch num {
        case 1_000_000...:
            return format(million) + "M"
        case 1_000...:
            return format(thousand) + "B"
        default:
            return String(Int(num))
        }
    }
}
