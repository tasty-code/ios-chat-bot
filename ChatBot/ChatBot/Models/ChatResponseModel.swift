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
    let logproblem: LogProblem?
    let finishReason: String
    
    enum CodingKeys: String, CodingKey {
        case index, message
        case logproblem = "logprobs"
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

struct LogProblem: Decodable {
    let content: [Content]
}

struct Content: Decodable {
    let token: String
    let logProblem: Double
    let bytes: [Int]?
    let topLogProblems: [TopLogproblem]
    
    enum CodingKeys: String, CodingKey {
        case token, bytes
        case logProblem = "logprob"
        case topLogProblems = "top_logprobs"
    }
}

struct TopLogproblem: Decodable {
    let token: String
    let logProblem: Double
    let bytes: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case token, bytes
        case logProblem = "logprob"
    }
}
