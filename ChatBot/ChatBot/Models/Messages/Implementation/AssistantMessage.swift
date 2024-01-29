//
//  AssistantMessage.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/03.
//

import Foundation

struct AssistantMessage: GPTMessageable {
    let role: MessageRole = .assistant
    
    var content: String?
    var name: String?
    var toolCalls: [ToolCalls]?
    
    init(content: String?, name: String? = nil, toolCalls: [ToolCalls]? = nil) {
        self.content = content
        self.name = name
        self.toolCalls = toolCalls
    }
    
    func toChatMessage() -> ChatMessage {
        return ChatMessage(content: content, role: role)
    }
}
