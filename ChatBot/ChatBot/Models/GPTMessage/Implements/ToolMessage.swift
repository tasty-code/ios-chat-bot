//
//  ToolMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

extension Model {
    struct ToolMessage: GPTMessagable {
        let role: GPTMessageRole
        let content: String?
        let toolCallID: String?
        
        init(requestMessage: GPTMessage) {
            self.role = .tool
            self.content = requestMessage.content
            self.toolCallID = requestMessage.toolCallID
        }
        
        func asRequestMessage() -> GPTMessage {
            GPTMessage(role: role, content: content, name: nil, toolCalls: nil, toolCallID: toolCallID)
        }
    }
}
