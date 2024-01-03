//
//  AssistantMessage.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/03.
//

import Foundation

struct AssistantMessage: GPTMessageable {
    let role: MessageRole
    
    var content: String?
    var name: String?
    var toolCalls: [ToolCalls]?
    
    init(content: String?, name: String?, toolCalls: [ToolCalls]?) {
        self.role = .assistant
        self.content = content
        self.name = name
        self.toolCalls = toolCalls
    }
    
    func converGPTMessageDTO() -> GPTMessageDTO {
        return GPTMessageDTO(role: "\(role)", content: content, name: name, toolCalls: toolCalls)
    }
}
