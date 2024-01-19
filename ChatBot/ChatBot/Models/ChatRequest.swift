//
//  APIRequest.swift
//  ChatBot
//
//  Created by Janine on 1/4/24.
//

import Foundation

struct ChatRequest: Encodable {
    let model: String
    let stream: Bool
    let messages: [ChatMessage]
}
