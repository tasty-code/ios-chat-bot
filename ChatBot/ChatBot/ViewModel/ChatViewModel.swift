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
    
    init(repository: MessageRepository, apiService: OpenAIService) {
        self.messageRepository = repository
        self.apiService = apiService
    }
    
    func processUserMessage(message content: String, model: GPTModel) {
        let userMessage = RequestMessageModel(role: .user, content: content)
        messageRepository.addMessage(userMessage)
        
        apiService.sendRequestToOpenAI(messageRepository.getMessages(), model: model, APIkey: APIKeyManager.openAIAPIKey) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let receivedMessages):
                    receivedMessages.forEach { responseMessage in
                        self?.messageRepository.addMessage(responseMessage)
                    }
                case .failure(let error):
                    self?.onError?("Error 발생: 관라자에게 문의해주세요 \(error.localizedDescription)")
                }
            }
        }
    }
}
