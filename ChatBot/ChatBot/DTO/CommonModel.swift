//
//  CommonModel.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/03.
//

import Foundation

struct Message: Codable {
    let role: Role
    let content: String?
}

enum Role: String, Codable {
    case system = "system"
    case user = "user"
    case assistant = "assistant"
}
