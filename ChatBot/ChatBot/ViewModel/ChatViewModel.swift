//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by 권태호 on 28/03/2024.
//

import Foundation

class ChatViewModel {
    private let repository: MessageRepository
    private let apiService: OpenAIService

    init(repository: MessageRepository, apiService: OpenAIService) {
        self.repository = repository
        self.apiService = apiService
    }

    func processUserMessage(_ content: String) {
        let userMessage = Message(role: "user", content: content)
        repository.addMessage(userMessage)
        let requestMessages = [RequestMessageModel(role: .user, content: content)]
        apiService.sendRequestToOpenAI(requestMessages) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let receivedMessages):
                    receivedMessages.forEach { responseMessage in
                        self?.repository.addMessage(responseMessage)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
