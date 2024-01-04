//
//  AssistantMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

extension Model {
    struct AssistantMessage: GPTMessagable {
        let role: GPTMessageRole
        let content: String?
        let name: String?
        let toolCalls: [GPTToolCall]?
        
        init(requestMessage: GPTMessage) {
            self.role = .assistant
            self.content = requestMessage.content
            self.name = requestMessage.name
            self.toolCalls = requestMessage.toolCalls
        }
        
        func asRequestMessage() -> GPTMessage {
            GPTMessage(role: role, content: content, name: name, toolCalls: toolCalls, toolCallID: nil)
        }
    }
}
