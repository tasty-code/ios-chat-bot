//
//  APIResponse.swift
//  ChatBot
//
//  Created by 동준 on 1/4/24.
//

import Foundation

struct ChatResponse: Decodable {
    let id: String
    let object: String
    let created: Date
    let model: String
    let systemFingerprint: String
    let choices: [Choice]
    let usage: Usage
    
    private enum CodingKeys: String, CodingKey {
        case id, object, created, model, choices, usage
        case systemFingerprint = "system_fingerprint"
    }
}

struct Choice: Decodable {
    let index: Int
    let message: ChatMessage
    let logprobs: LogProbs?
    let finishReason: FinishReason
    
    enum FinishReason: String, Decodable {
        case stop
        case length
        case contentFilter = "content_filter"
        case toolCalls = "tool_calls"
        case functionCall = "function_call"
    }
    
    private enum CodingKeys: String, CodingKey {
        case index, message, logprobs
        case finishReason = "finish_reason"
    }
}

struct Usage: Decodable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    private enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

struct LogProbs: Decodable {
    let content: [Content]?
    let topLogprobs: [TopLogProbs]?
}

struct Content: Decodable {
    let token: String
    let logprob: Double
    let bytes: [Int]?
}

struct TopLogProbs: Decodable {
    let token: String
    let logprob: Double
}
