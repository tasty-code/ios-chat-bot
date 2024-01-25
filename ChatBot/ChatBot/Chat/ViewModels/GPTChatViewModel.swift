//
//  GPTChatViewModel.swift
//  ChatBot
//
//  Created by 김진웅 on 1/13/24.
//

import Foundation

final class GPTChatViewModel {
    private let serviceProvider: ServiceProvidable
    
    private var messages: [GPTMessageDTO] = [] {
        didSet {
            didMessagesAppend?(messages)
        }
    }
    
    var didMessagesAppend: (([GPTMessageDTO]) -> Void)?
    
    init(serviceProvider: ServiceProvidable) {
        self.serviceProvider = serviceProvider
    }
    
    func fetch(userInput: String) {
        let userMessageDTO = UserMessage(content: userInput).convertGPTMessageDTO()
        messages.append(userMessageDTO)
        let requestDTO = GPTRequestDTO(stream: false, messages: messages)
        
        let assistantMessageDTO = AssistantMessage(content: nil).convertGPTMessageDTO()
        messages.append(assistantMessageDTO)
        
        Task {
            do {
                let responseDTO: GPTResponseDTO = try await serviceProvider.excute(for: GPTEndPoint.chatbot(body: requestDTO))
                if let messageDTO = responseDTO.choices.first?.message {
                    addResponseMessage(messageDTO)
                }
            } catch {
                let assistantMessageDTO = AssistantMessage(content: "\(error)").convertGPTMessageDTO()
                addResponseMessage(assistantMessageDTO)
            }
        }
    }
    
    private func addResponseMessage(_ messageDTO: GPTMessageDTO) {
        Task { @MainActor in
            messages[messages.count - 1] = messageDTO
        }
    }
}
