//
//  UserMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/3/24.
//

extension Model {
    struct UserMessage: GPTMessagable {
        let role: Model.GPTMessageRole
        let content: String?
        let name: String?
        
        init(content: String, name: String? = nil) {
            self.role = .user
            self.content = content
            self.name = name
        }
        
        init(requestMessage: Model.GPTMessage) {
            self.role = .user
            self.content = requestMessage.content
            self.name = requestMessage.name
        }
        
        func asRequestMessage() -> Model.GPTMessage {
            Model.GPTMessage(role: role, content: content, name: name, toolCalls: nil, toolCallID: nil)
        }
    }
}
