//
//  ChatCommonModel.swift
//  ChatBot
//
//  Created by Kim EenSung on 3/26/24.
//

import Foundation

struct Message: Codable {
    let role: ChatRole
    let content: String
}

enum GPTModelFamilies: String, Codable {
    case main = "gpt-3.5-turbo-1106"
}

enum ChatRole: String, Codable {
    case system
    case user
    case assistant
}
