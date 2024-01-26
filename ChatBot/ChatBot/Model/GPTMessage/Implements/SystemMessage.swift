//
//  SystemMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

extension Model {
    struct SystemMessage: GPTMessagable {
        let role: GPTMessageRole
        let content: String?
        let name: String?
        
        init(content: String? , name: String?) {
            self.role = .system
            self.content = content
            self.name = name
        }
        
        init(requestMessage: GPTMessage) {
            self.role = .system
            self.content = requestMessage.content
            self.name = requestMessage.name
        }
        
        func asRequestMessage() -> GPTMessage {
            GPTMessage(role: role, content: content, name: name, toolCalls: nil, toolCallID: nil)
        }
    }
}
