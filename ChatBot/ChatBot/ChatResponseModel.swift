//
//  ChatCompletionDTOs.swift
//  ChatBot
//
//  Created by Kim EenSung on 3/26/24.
//

import Foundation

struct ChatResponseModel: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: GPTModelFamilies
    let choices: [Choice]
    let usage: Usage
    let systemFingerprint: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case model
        case choices
        case usage
        case systemFingerprint = "system_fingerprint"
    }
}

struct Choice: Decodable {
    let index: Int
    let message: Message
    let logprobs: String?
    let finishReason: String
    
    enum CodingKeys: String, CodingKey {
        case index
        case message
        case logprobs
        case finishReason = "finish_reason"
    }
}

struct Usage: Decodable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
