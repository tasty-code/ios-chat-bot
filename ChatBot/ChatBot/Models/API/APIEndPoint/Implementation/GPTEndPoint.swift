//
//  GPTEndPoint.swift
//  ChatBot
//
//  Created by 김진웅 on 1/5/24.
//

import Foundation

enum GPTEndPoint {
    case chatbot(body: RequestDTOEncodable)
}

extension GPTEndPoint: APIEndPoint {
    var scheme: String {
        switch self {
        case .chatbot:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case .chatbot:
            return "api.openai.com"
        }
    }
    
    var path: String {
        switch self {
        case .chatbot:
            return "/v1/chat/completions"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .chatbot:
            return .post
        }
    }
    
    var headerFields: [String : String]? {
        get throws {
            switch self {
            case .chatbot:
                guard let apiKey = Bundle.main.gptAPIKey 
                else {
                    throw APIError.notFoundAPIKey
                }
                return ["Authorization": "Bearer \(apiKey)",
                        "Content-Type" : "application/json"]
            }
        }
    }
    
    var encodableBody: Encodable? {
        switch self {
        case .chatbot(let body):
            return body
        }
    }
}
