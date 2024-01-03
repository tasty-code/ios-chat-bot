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
    let finishReason: String
    
    enum CodingKeys: String, CodingKey {
        case finishReason = "finish_reason"
        case index, message
    }
}

enum FinishReason {
    case stop
    case length
    case contentFilter
}
