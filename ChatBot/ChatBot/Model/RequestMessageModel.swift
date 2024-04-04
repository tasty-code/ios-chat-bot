//
//  RequestMessageModel.swift
//  ChatBot
//
//  Created by 권태호 on 28/03/2024.
//

import Foundation

struct RequestMessageModel: Encodable {
    let role: MessageRole
    let content: String
}

enum MessageRole: String, Codable {
    case user = "user"
    case assistant = "assistant"
    case system = "system"
}
