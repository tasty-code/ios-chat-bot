//
//  GPTMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

extension Model {
    struct GPTMessage: Codable, GPTMessagable {
        let role: GPTMessageRole
        let content: String?
        let name: String?
        let toolCalls: [GPTToolCall]?
        let toolCallID: String?
        
        init(requestMessage: Model.GPTMessage) {
            self.role = requestMessage.role
            self.content = requestMessage.content
            self.name = requestMessage.name
            self.toolCalls = requestMessage.toolCalls
            self.toolCallID = requestMessage.toolCallID
        }
        
        func asRequestMessage() -> Model.GPTMessage { self }
    }
}

extension Model.GPTMessage {
    enum CodingKeys: String, CodingKey {
        case role
        case content
        case name
        case toolCalls = "tool_calls"
        case toolCallID = "tool_call_id"
    }
}

extension Model {
    struct GPTToolCall: Codable {
        var id: String
        var type: String
        var function: Function
    }
}

extension Model.GPTToolCall {
    struct Function: Codable {
        var name: String
        var arguments: String
    }
}
