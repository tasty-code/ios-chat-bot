//
//  MessageRepository.swift
//  ChatBot
//
//  Created by 권태호 on 28/03/2024.
//

import Foundation

protocol MessageRepositoryDeletage: AnyObject {
    func messageDidUpdate()
}

class MessageRepository {
    private var messagesStorage: [RequestMessageModel] = []
    private let repoQueue = DispatchQueue(label: "repoQueue")
    weak var delegate: MessageRepositoryDeletage?
    
    func addMessage(_ message: RequestMessageModel) {
        repoQueue.async {
            self.messagesStorage.append(message)
            self.delegate?.messageDidUpdate()
        }
    }
    
    func getMessages() -> [RequestMessageModel] {
        return repoQueue.sync {
            messagesStorage
        }
    }
    
    func clearStorage() {
        repoQueue.sync {
            self.messagesStorage.removeAll()
            self.delegate?.messageDidUpdate()
        }
    }
}
