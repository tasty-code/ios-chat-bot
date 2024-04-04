//
//  ChatMessage.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/4/24.
//

import Foundation

struct ChatMessage: Hashable {
    let id: UUID
    let isUser: Bool
    let message: String
}
