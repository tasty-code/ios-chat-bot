//
//  Path.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/09.
//

import Foundation

enum Path: String {
    case chat

    var value: String {
        switch self {
        case .chat:
            return "/v1/chat/completions"
        }
    }
}
