//
//  Usage.swift
//  ChatBot
//
//  Created by Matthew on 3/27/24.
//

import Foundation

// MARK: - Usage
struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
