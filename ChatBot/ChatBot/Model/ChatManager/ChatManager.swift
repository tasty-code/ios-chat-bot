//
//  ChatManager.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/24/24.
//

import Foundation

final class ChatManager {
    
    private var chats: [ChatBubble] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("ChatsUpdatedNotification"), object: nil)
        }
    }
    func appendChat(question: String) {
        
        chats.append(ChatBubble(message: Message(role: "user", content: question)))
        chats.append(ChatBubble(message: Message(role: "assistant", content: "")))
    }
    
    func getChats() -> [ChatBubble] {
        return self.chats
    }
    
    func responseChat(answer: String) {
        chats[chats.count - 1] = ChatBubble(message: Message(role: "assistant", content: answer))
    }
    
    func removeLastChat() {
        chats.removeLast()
    }
}
