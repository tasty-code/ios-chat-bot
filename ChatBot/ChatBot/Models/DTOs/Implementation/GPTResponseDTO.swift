//
//  GPTResponseDTO.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/03.
//

import Foundation

struct GPTResponseDTO: ResponseDTODecodable {
    let id: String
    let object: String
    let created: Date
    let model: String
    let systemFingerprint: String
    let choices: [Choice]
    let usage: Usage
    
    enum CodingKeys: String, CodingKey {
        case id, object, created, model, choices, usage
        case systemFingerprint = "system_fingerprint"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timeInterval = try container.decode(Double.self, forKey: .created)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.object = try container.decode(String.self, forKey: .object)
        self.created = Date(timeIntervalSince1970: timeInterval)
        self.model = try container.decode(String.self, forKey: .model)
        self.choices = try container.decode([Choice].self, forKey: .choices)
        self.usage = try container.decode(Usage.self, forKey: .usage)
        self.systemFingerprint = try container.decode(String.self, forKey: .systemFingerprint)
    }
}

struct Choice: Decodable {
    let index: Int
    let message: GPTMessageDTO
    let finishReason: String
    
    enum CodingKeys: String, CodingKey {
        case index, message
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
