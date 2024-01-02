//
//  AssistantMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

struct AssistantMessage: GPTMessagable {
    let role: GPTMessageRole = .assistant
    let content: String?
    let name: String?
    let toolCalls: [GPTToolCall]?
    
    enum CodingKeys: String, CodingKey {
        case role
        case content
        case name
        case toolCalls = "tool_calls"
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
