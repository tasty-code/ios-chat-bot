//
//  ChatMessage.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/25/24.
//

import Foundation

struct ChatMessage {
    let uuid: UUID
    let date: Date
    var content: String?
    var role: MessageRole
    
    init(uuid: UUID = UUID(), date: Date = Date(), content: String?, role: MessageRole) {
        self.uuid = uuid
        self.date = date
        self.content = content
        self.role = role
    }
    
    func toMessageDTO() -> GPTMessageDTO {
        return GPTMessageDTO(role: role, content: content)
    }
}

extension ChatMessage: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid)
    }
}
