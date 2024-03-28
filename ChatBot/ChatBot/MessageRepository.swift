//
//  MessageRepository.swift
//  ChatBot
//
//  Created by 권태호 on 28/03/2024.
//

import Foundation

class MessageRepository {
    
    var messagesStorage: [Message] = []
    
    func addMessage(_ message: Message) {
        messagesStorage.append(message)
    }
    func getMessages() -> [Message] {
        return messagesStorage
    }
    func clearStorage() {
        messagesStorage.removeAll()
    }
}
