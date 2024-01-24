//
//  ChatUseCase.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/24/24.
//

import Foundation

final class ChatUseCase {
    private let chatManager = ChatManager()
    private let chatService = ChatService()
    
    func appendQuestion(question: String, completionHandler: () -> ()) {
        chatManager.appendChat(question: question)
        completionHandler()
    }
    
    func sendQuestion(successCompletion: @escaping () -> (), failureCompletion: @escaping () -> () ) {
        let chats = chatManager.getChats()
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            try? self.chatService.sendChats(chats: chats , completion: { result in
                switch result {
                case .success(let success):
                    let answer = success.choices[0].message.content
                    self.chatManager.responseChat(answer: answer)
                    successCompletion()
                case .failure:
                    failureCompletion()
                }
            })
        }
    }
    
    func removeLastChat() {
        chatManager.removeLastChat()
    }
    
    func getChats() -> [ChatBubble] {
        return chatManager.getChats()
    }
}
