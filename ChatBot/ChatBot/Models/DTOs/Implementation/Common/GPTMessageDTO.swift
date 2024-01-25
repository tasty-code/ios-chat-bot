//
//  GPTMessageDTO.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/03.
//

import Foundation

struct GPTMessageDTO: Codable {
    let uuid: UUID
    let role: MessageRole
    
    var content: String?
    var name: String?
    var toolCalls: [ToolCalls]?
    
    enum CodingKeys: String, CodingKey {
        case role, content, name
        case toolCalls = "tool_calls"
    }
    
    init(uuid: UUID = UUID(), role: MessageRole, content: String? = nil, name: String? = nil, toolCalls: [ToolCalls]? = nil) {
        self.uuid = uuid
        self.role = role
        self.content = content
        self.name = name
        self.toolCalls = toolCalls
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = UUID()
        self.role = try container.decode(MessageRole.self, forKey: .role)
        self.content = try container.decode(String.self, forKey: .content)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.toolCalls = try container.decodeIfPresent([ToolCalls].self, forKey: .toolCalls)
    }
}

enum MessageRole: String, Codable {
    case user
    case system
    case assistant
}

struct ToolCalls: Codable {
    let id: String
    let type: String
    let function: Function
}

struct Function: Codable {
    let name: String
    let arguments: String
}
