//
//  Message.swift
//  ChatBot
//
//  Created by 전성수 on 1/12/24.
//

import Foundation

// MARK: - Message
struct Message: Codable, Hashable, Identifiable {
    let id: UUID = UUID()
    let role: String
    let content: String
    
    enum CodingKeys: CodingKey {
        case role
        case content
    }
}

extension Message {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}
