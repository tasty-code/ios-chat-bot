//
//  WaitingMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/12/24.
//

extension Model {
    struct WaitingMessage: GPTMessagable {
        let role: Model.GPTMessageRole
        let content: String?
        
        init() {
            role = .waiting
            content = nil
        }
        
        init(requestMessage: Model.GPTMessage) {
            role = .waiting
            content = nil
        }
        
        func asRequestMessage() -> Model.GPTMessage {
            Model.GPTMessage(role: .waiting, content: nil, name: nil, toolCalls: nil, toolCallID: nil)
        }
    }
}
