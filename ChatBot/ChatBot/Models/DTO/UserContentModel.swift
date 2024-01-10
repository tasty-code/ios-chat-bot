//
//  UserContentModel.swift
//  ChatBot
//
//  Created by 전성수 on 1/3/24.
//

import Foundation

// MARK: - UserContentModel
struct UserContentModel: Encodable {
    let model: String
    let stream: Bool
    let userMessage: [UserMessage]
    
    enum CodingKeys: String, CodingKey {
        case model, stream
        case userMessage = "messages"
    }
}

// MARK: - Message
struct UserMessage: Encodable {
    let role: String
    let content: String
}
