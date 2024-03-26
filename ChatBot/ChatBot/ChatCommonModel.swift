//
//  ChatCommonModel.swift
//  ChatBot
//
//  Created by Kim EenSung on 3/26/24.
//

import Foundation

// MARK: - Message
struct Message: Codable {
    let role: ChatRole
    let content: String
}

// MARK: - APIModel
enum GPTModelFamilies: String, Codable {
    case main = "gpt-3.5-turbo-1106"
}

// MARK: - APIRole
enum ChatRole: String, Codable {
    case system = "system"
    case user = "user"
    case assistant = "assistant"
}
