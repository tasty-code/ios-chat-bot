//
//  APIType.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/26/24.
//

import Foundation

enum APIType {
    case chatGPT(Message)
    
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
    
    var queries: [URLQueryItem]? {
        switch self {
        case .chatGPT(let message):
            return [
                URLQueryItem(name: "model", value: "gpt-3.5-turbo-1106"),
                URLQueryItem(name: "message", value: "\(message.content)")
            ]
        }
    }
    
    var path: String {
        switch self {
        case .chatGPT:
            return "/v1/chat/completions"
        }
    }
}

