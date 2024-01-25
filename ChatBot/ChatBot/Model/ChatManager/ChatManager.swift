//
//  ChatManager.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/24/24.
//

import Foundation

final class ChatManager {
    private let chatUseCase = ChatUseCase()
    
    private var chats: [ChatBubble] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("ChatsUpdatedNotification"), object: nil)
        }
    }
    
    func getChats() -> [ChatBubble] {
        return self.chats
    }
    
    func appendChat(question: String) {
        chats.append(ChatBubble(message: Message(role: "user", content: question)))
        chats.append(ChatBubble(message: Message(role: "assistant", content: "")))
    }
    
    func sendQuestion(successCompletion: @escaping () -> (), failureCompletion: @escaping () -> ()) {
        chatUseCase.sendQuestion(chats: self.chats) { [weak self] answer in
            guard let self = self else { return }
            self.responseChat(answer: answer)
            successCompletion()
        } failureCompletion: {
            failureCompletion()
        }
    }
    
    func responseChat(answer: String) {
        chats[chats.count - 1] = ChatBubble(message: Message(role: "assistant", content: answer))
    }
    
    func removeLastChat() {
        chats.removeLast()
    }
}
