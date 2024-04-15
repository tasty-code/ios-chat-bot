//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by 권태호 on 28/03/2024.
//

import Foundation

final class ChatViewModel {
    let messageRepository: MessageRepository
    private let apiService: OpenAIService
    
    var onError:((String) -> Void)?
    var onMessagesUpdated: (() -> Void)?
    
    init(repository: MessageRepository, apiService: OpenAIService) {
        self.messageRepository = repository
        self.apiService = apiService
    }
    
    func processUserMessage(message content: String, model: GPTModel, completion: @escaping () -> Void) {
        let userMessage = RequestMessageModel(role: .user, content: content)
        messageRepository.addMessage(userMessage)
        self.onMessagesUpdated?()
        
        apiService.sendRequestToOpenAI(messageRepository.getMessages(),
                                       model: model,
                                       APIkey: APIKeyManager.openAIAPIKey) { [weak self] result in
            switch result {
            case .success(let receivedMessages):
                receivedMessages.forEach { responseMessage in
                    self?.messageRepository.addMessage(responseMessage)
                }
                self?.onMessagesUpdated?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
            completion()
        }
    }
}

