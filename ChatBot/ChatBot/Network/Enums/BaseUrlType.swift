//
//  BaseUrlType.swift
//  ChatBot
//
//  Created by Janine on 1/5/24.
//

import Foundation

enum BaseUrlType {
    case gpt
    
    var url: String {
        switch self {
        case .gpt:
            return "https://api.openai.com/"
        }
    }
}
