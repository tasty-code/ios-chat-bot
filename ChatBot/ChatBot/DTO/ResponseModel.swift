//
//  ResponseModel.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/03.
//

import Foundation

struct ResponseModel: Decodable {
    let id: String
    let created: Int
    let choices: [Choice]
}

struct Choice: Decodable {
    let index: Int
    let message: Message
    let finishReason: FinishReason?
    
    private enum CodingKeys: String, CodingKey {
        case finishReason = "finish_reason"
        case index, message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.finishReason = try container.decode(FinishReason.self, forKey: .finishReason)
        self.index = try container.decode(Int.self, forKey: .index)
        self.message = try container.decode(Message.self, forKey: .message)
    }
}

enum FinishReason: String, Decodable {
    case stop
    case length
    case contentFilter = "content_filter"
    case toolCalls = "tool_calls"
}
