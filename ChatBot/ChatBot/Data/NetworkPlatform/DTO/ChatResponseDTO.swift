//
//  ChatResponseDTO.swift
//  ChatBot
//
//  Created by ㅣ on 3/26/24.
//

import Foundation

struct ChatResponseDTO: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let systemFingerprint: String
    let choices: [ChatChoiceDTO]
    let usage: Usage

    private enum CodingKeys: String, CodingKey {
        case id, object, created, model, choices, usage
        case systemFingerprint = "system_fingerprint"
    }
}

struct ChatChoiceDTO: Decodable {
    let index: Int
    let message: ChatMessageDTO
    let finishReason: String
    
    private enum CodingKeys: String, CodingKey {
        case index, message
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
