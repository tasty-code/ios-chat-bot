//
//  APIType.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/26/24.
//

import Foundation

enum APIType {
    case chatGPT
    
    var host: String? {
        switch self {
        case .chatGPT:
            return "api.openai.com"
        }
    }
    
    var header: [String:String]? {
        switch self {
        case .chatGPT:
            return ["Authorization": "Bearer \(Bundle.main.chatApi)"]
        }
    }
    
    var path: String {
        switch self {
        case .chatGPT:
            return "/v1/chat/completions"
        }
    }
}

