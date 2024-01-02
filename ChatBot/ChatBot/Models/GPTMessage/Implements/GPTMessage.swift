//
//  GPTMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

struct GPTMessage: Codable {
    let role: GPTMessageRole
    let content: String?
    let name: String?
    let toolCalls: [GPTToolCall]?
    let toolCallID: String?
}

extension GPTMessage {
    enum CodingKeys: String, CodingKey {
        case role
        case content
        case name
        case toolCalls = "tool_calls"
        case toolCallID = "tool_call_id"
    }
}

struct GPTToolCall: Codable {
    var id: String
    var type: String
    var function: Function
}

extension GPTToolCall {
    struct Function: Codable {
        var name: String
        var arguments: String
    }
}
