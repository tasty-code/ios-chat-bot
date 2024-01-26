//
//  APIKeyName.swift
//  ChatBot
//
//  Created by 전성수 on 1/10/24.
//

import Foundation

enum APIKeyName {
    case openAI
    
    var description: String {
        switch self {
        case .openAI: "openAI_APIKey"
        }
    }
}
