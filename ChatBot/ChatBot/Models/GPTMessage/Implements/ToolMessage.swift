//
//  ToolMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

struct ToolMessage: GPTMessagable {
    var role: GPTMessageRole = .tool
    var content: String?
    var toolCallID: String?
    
    enum CodingKeys: String, CodingKey {
        case role
        case content
        case toolCallID = "tool_call_id"
    }
}
