//
//  GPTResponseBody.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

import Foundation

struct GPTResponseBody: Decodable, Identifiable {
    let id: String
    let choices: [GPTChoice]
    let createdDate: Date
    let model: String
    let systemFingerPrint: String
    let object: String
    let usage: Usage
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.choices = try container.decode([GPTChoice].self, forKey: .choices)
        self.createdDate = Date(unixTimeStamp: try container.decode(UInt.self, forKey: .createdDate))
        self.model = try container.decode(String.self, forKey: .model)
        self.systemFingerPrint = try container.decode(String.self, forKey: .systemFingerPrint)
        self.object = try container.decode(String.self, forKey: .object)
        self.usage = try container.decode(GPTResponseBody.Usage.self, forKey: .usage)
    }
}

extension GPTResponseBody {
    enum CodingKeys: String, CodingKey {
        case id
        case choices
        case createdDate = "created"
        case model
        case systemFingerPrint
        case object
        case usage
    }
    
    struct Usage: Decodable {
        let completionTokens: Int
        let promptTokens: Int
        let totalTokens: Int
        
        enum CodingKeys: String, CodingKey {
            case completionTokens = "completion_tokens"
            case promptTokens = "prompt_tokens"
            case totalTokens = "total_tokens"
        }
    }
}

struct GPTChoice: Decodable {
    let index: Int
    let finishReason: FinishReason
    let message: GPTMessage
}

extension GPTChoice {
    enum CodingKeys: String, CodingKey {
        case index
        case finishReason = "finish_reason"
        case message
    }
    
    enum FinishReason: String, Decodable {
        case stop
        case length
        case contentFilter = "content_filter"
        case toolCalls
    }
}
