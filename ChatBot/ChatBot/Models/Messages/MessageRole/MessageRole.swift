//
//  MessageRole.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/03.
//

import Foundation

enum MessageRole: String, CustomStringConvertible {
    case user
    case system
    case assistant
    
    var description: String {
        switch self {
        case .user:
            return "user"
        case .system:
            return "system"
        case .assistant:
            return "assistant"
        }
    }
}
