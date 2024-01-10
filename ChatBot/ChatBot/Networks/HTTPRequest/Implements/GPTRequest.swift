//
//  GPTRequest.swift
//  ChatBot
//
//  Created by 김준성 on 1/10/24.
//

import Foundation

extension Network {
    enum GPTRequest {
        case chatBot(apiKey: String)
    }
}

extension Network.GPTRequest: HTTPRequestable {
    var urlString: String? { "https://api.openai.com" }
    
    var paths: [String]? {
        switch self {
        case .chatBot:
            return ["v1", "chat", "completions"]
        }
    }
    
    var queryStrings: [String: CustomStringConvertible]? {
        switch self {
        case .chatBot:
            return nil
        }
    }
    
    var headerFields: [String: String]? {
        switch self {
        case .chatBot(let apiKey):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ]
        }
    }
    
    var httpMethod: Network.HTTPMethod {
        switch self {
        case .chatBot:
            return .post
        }
    }
}
