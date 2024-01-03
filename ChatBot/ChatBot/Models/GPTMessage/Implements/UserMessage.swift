//
//  UserMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/3/24.
//

struct UserMessage: GPTMessagable {
    let role: GPTMessageRole
    let content: String?
    let name: String?
    
    init(requestMessage: GPTMessage) {
        self.role = .user
        self.content = requestMessage.content
        self.name = requestMessage.name
    }
    
    func asRequestMessage() -> GPTMessage {
        GPTMessage(role: role, content: content, name: name, toolCalls: nil, toolCallID: nil)
    }
}
