//
//  CommonModel.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/03.
//

import Foundation

struct Message: Codable, Hashable {
    let role: Role
    let content: String?
}

enum Role: String, Codable, Hashable {
    case system = "system"
    case user = "user"
    case assistant = "assistant"
}
