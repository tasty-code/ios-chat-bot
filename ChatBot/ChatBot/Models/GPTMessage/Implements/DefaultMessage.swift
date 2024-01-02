//
//  DefaultMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

struct DefaultMessage: GPTMessagable {
    let role: GPTMessageRole
    let content: String?
    let name: String?
    
    init(requestMessage: GPTMessage) {
        self.role = requestMessage.role
        self.content = requestMessage.content
        self.name = requestMessage.name
    }
    
    func asRequestMessage() -> GPTMessage {
        GPTMessage(role: role, content: content, name: name, toolCalls: nil, toolCallID: nil)
    }
}
