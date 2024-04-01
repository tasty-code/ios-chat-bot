//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by 권태호 on 28/03/2024.
//

import Foundation

final class ChatViewModel {
    private let messageRepository: MessageRepository
    private let apiService: OpenAIService

    init(repository: MessageRepository, apiService: OpenAIService) {
        self.messageRepository = repository
        self.apiService = apiService
    }

    func processUserMessage(_ content: String) {
        let userMessage = Message(role: "user", content: content)
        
        messageRepository.addMessage(userMessage)
        
        let requestMessages = [RequestMessageModel(role: .user, content: content)]
        
        apiService.sendRequestToOpenAI(requestMessages) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let receivedMessages):
                    receivedMessages.forEach { responseMessage in
                        self?.messageRepository.addMessage(responseMessage)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
