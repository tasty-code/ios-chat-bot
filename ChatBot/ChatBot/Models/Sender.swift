//
//  Sender.swift
//  ChatBot
//
//  Created by 김예준 on 1/17/24.
//

import Foundation

enum Sender: String, CustomStringConvertible {
    case assistant
    case user
    
    var description: String {
        switch self {
        case .assistant:
            return "assistant"
        case .user:
            return "user"
        }
    }
}
