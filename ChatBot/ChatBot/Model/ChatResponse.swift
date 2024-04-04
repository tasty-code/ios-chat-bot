//
//  ChatResponse.swift
//  ChatBot
//
//  Created by yujaehong on 3/28/24.
//

import Foundation

struct ChatResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let systemFingerprint: String
    let choices: [Choice]
    let usage: Usage
}

struct Choice: Codable {
    let index: Int
    let message: Message
    let finishReason: String
    
    enum CodingKeys: String, CodingKey {
        case index
        case message
        case finishReason = "finish_reason"
    }
}

struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

