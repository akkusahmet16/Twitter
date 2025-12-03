//
//  XModels.swift
//  Twitter
//
//  Created by Akkuş on 30.11.2025.
//

import Foundation

struct XTPost: Identifiable, Codable {
    
    let id: String
    let text: String
    
}

struct XTUserTimeLineResponse: Codable {
    let data: [XTPost]?
}
