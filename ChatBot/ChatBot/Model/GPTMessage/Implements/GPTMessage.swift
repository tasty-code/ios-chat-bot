//
//  GPTMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

import Foundation

extension Model {
    struct GPTMessage: GPTMessagable, Identifiable {
        let id: UUID
        let role: GPTMessageRole
        let content: String?
        let name: String?
        let toolCalls: [GPTToolCall]?
        let toolCallID: String?
        
        init(id: UUID = UUID(), role: GPTMessageRole, content: String?, name: String?, toolCalls: [GPTToolCall]?, toolCallID: String?) {
            self.id = id
            self.role = role
            self.content = content
            self.name = name
            self.toolCalls = toolCalls
            self.toolCallID = toolCallID
        }
        
        init(requestMessage: Model.GPTMessage) {
            self.id = requestMessage.id
            self.role = requestMessage.role
            self.content = requestMessage.content
            self.name = requestMessage.name
            self.toolCalls = requestMessage.toolCalls
            self.toolCallID = requestMessage.toolCallID
        }
        
        func asRequestMessage() -> Model.GPTMessage { self }
    }
}

extension Model.GPTMessage: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case role
        case content
        case name
        case toolCalls = "tool_calls"
        case toolCallID = "tool_call_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.role = try container.decode(Model.GPTMessageRole.self, forKey: .role)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.toolCalls = try container.decodeIfPresent([Model.GPTToolCall].self, forKey: .toolCalls)
        self.toolCallID = try container.decodeIfPresent(String.self, forKey: .toolCallID)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(role, forKey: .role)
        try container.encodeIfPresent(content, forKey: .content)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(toolCalls, forKey: .toolCalls)
        try container.encodeIfPresent(toolCallID, forKey: .toolCallID)
    }
}

extension Model.GPTMessage: Hashable {
    static func == (lhs: Model.GPTMessage, rhs: Model.GPTMessage) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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
