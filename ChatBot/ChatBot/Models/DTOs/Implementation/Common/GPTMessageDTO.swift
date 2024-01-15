//
//  GPTMessageDTO.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/03.
//

import Foundation

struct GPTMessageDTO: Codable {
    let uuid: UUID = UUID()
    let role: String
    
    var content: String?
    var name: String?
    var toolCalls: [ToolCalls]?
    
    enum CodingKeys: String, CodingKey {
        case role, content, name
        case toolCalls = "tool_calls"
    }
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
