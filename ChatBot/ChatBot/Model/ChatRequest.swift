//
//  ChatRequest.swift
//  ChatBot
//
//  Created by yujaehong on 3/28/24.
//

import Foundation

struct ChatRequest: Codable {
    let model: GPTModel
    let stream: Bool
    let messages: [Message]
}

enum GPTModel: String, Codable {
    case main = "gpt-3.5-turbo-1106"
}
