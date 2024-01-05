//
//  Message.swift
//  ChatBot
//
//  Created by Wonji Ha on 1/3/24.
//

import Foundation

struct Message: Codable {
    let role: String
    let content: String?
    let toolCalls: [Toolcalls]?
    
    enum CodingKeys: String, CodingKey {
        case role, content
        case toolCalls = "tool_calls"
    }
}

struct Toolcalls: Codable {
    let id, type: String
    let function: Function
    
}

struct Function: Codable {
    let name, arguments: String
}


