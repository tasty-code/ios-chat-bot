//
//  ChatResponseModel.swift
//  ChatBot
//
//  Created by 김예준 on 1/3/24.
//

import Foundation

struct ChatResponseModel: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let systemFingerprint: String?
    let choices: [Choice]
    let usage: Usage
    
    enum CodingKeys: String, CodingKey {
        case id, object, created, model, choices, usage
        case systemFingerprint = "system_fingerprint"
    }
}

struct Choice: Decodable {
    let index: Int
    let message: Message
    let logProblems: Int?
    let finishReason: String
    
    enum CodingKeys: String, CodingKey {
        case index, message
        case logProblems = "logprobs"
        case finishReason = "finish_reason"
    }
}

struct Usage: Decodable {
    let promptTokens: Int?
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_okens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
