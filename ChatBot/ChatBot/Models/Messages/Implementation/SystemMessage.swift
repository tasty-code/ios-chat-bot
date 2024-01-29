//
//  SystemMessage.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/03.
//

import Foundation

struct SystemMessage: GPTMessageable {
    let role: MessageRole = .system
    
    var content: String?
    var name: String?
    
    init(content: String?, name: String? = nil) {
        self.content = content
        self.name = name
    }
    
    func toChatMessage() -> ChatMessage {
        return ChatMessage(content: content, role: role)
    }
}
