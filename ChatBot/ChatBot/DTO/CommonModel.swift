//
//  CommonModel.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/03.
//

import Foundation

struct Message: Codable, Identifiable {
    let id = UUID()
    let role: Role
    let content: String?
    
    enum CodingKeys: CodingKey {
        case role
        case content
    }
}

extension Message: Hashable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum Role: String, Codable {
    case system = "system"
    case user = "user"
    case assistant = "assistant"
}
