//
//  GPTMessageable.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/03.
//

import Foundation

protocol GPTMessageable {
    var role: MessageRole { get }
    var content: String? { get set }
    var name: String? { get set }
    
    func toChatMessage() -> ChatMessage
}
