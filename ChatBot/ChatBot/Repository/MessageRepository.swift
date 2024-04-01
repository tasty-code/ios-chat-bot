//
//  MessageRepository.swift
//  ChatBot
//
//  Created by 권태호 on 28/03/2024.
//

import Foundation

class MessageRepository {
    
    var messagesStorage: [RequestMessageModel] = []
    
    func addMessage(_ message: RequestMessageModel) {
        messagesStorage.append(message)
    }
    func getMessages() -> [RequestMessageModel] {
        return messagesStorage
    }
    func clearStorage() {
        messagesStorage.removeAll()
    }
}
