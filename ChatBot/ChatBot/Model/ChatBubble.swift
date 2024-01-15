//
//  ChatBubble.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/15.
//

import Foundation

struct ChatBubble: Hashable {
    let uuid = UUID()
    let message: Message
    
    static func == (lhs: ChatBubble, rhs: ChatBubble) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
