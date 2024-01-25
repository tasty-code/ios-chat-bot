//
//  ChatUseCase.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/24/24.
//

import Foundation

final class ChatUseCase {
    
    private let chatService = ChatService()
    
    func sendQuestion(chats: [ChatBubble], successCompletion: @escaping (String) -> (), failureCompletion: @escaping () ->() ) {
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            try? self.chatService.sendChats(chats: chats, completion: { result in
                switch result {
                case .success(let success):
                    let answer = success.choices[0].message.content
                    successCompletion(answer)
                case .failure:
                    failureCompletion()
                }
            })
        }
    }
}
