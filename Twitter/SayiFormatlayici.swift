//
//  SayiFormatlayici.swift
//  Twitter
//
//  Created by Akkuş on 29.11.2025.
//

import Foundation


//MARK: - Eski Formatlayıcı

extension Int{
    var abbreviated: String{
        let num = Double(self)
        
        switch num{
        case 1_000_000_000...:
            return String(format: "%.1fB", num / 1_000_000_000).replacingOccurrences(of: ".0", with: "")
            
        case 1_000_000...:
            return String(format: "%.1fM", num / 1_000_000).replacingOccurrences(of: ".0", with: "")
            
        case 1_000...:
            return String(format: "%.1fM", num / 1_000_000).replacingOccurrences(of: ".0", with: "")
            
        default:
            return "\(self)"
            
        }
    }
}


//MARK: - Yeni Formatlayıcı

/*
extension Int {
    var abbreviated: String {
        let num = Double(self)
        
        let thousand = num / 1_000
        let million = num / 1_000_00
        
        // -> 1M Üstü
        if million >= 1 {
            return format(million) + "M"
        }
        // -> 1K üstü
        if thousand >= 1 {
            return format(thousand) + "B"
        }
        
        return "\(self)"
        
    }
}
*/
