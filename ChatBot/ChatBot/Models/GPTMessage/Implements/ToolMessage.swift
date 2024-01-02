//
//  ToolMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

struct ToolMessage: GPTMessagable {
    let role: GPTMessageRole = .tool
    let content: String?
    let toolCallID: String?
    
    enum CodingKeys: String, CodingKey {
        case role
        case content
        case toolCallID = "tool_call_id"
    }
}
