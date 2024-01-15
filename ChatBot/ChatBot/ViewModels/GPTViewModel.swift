//
//  GPTViewModel.swift
//  ChatBot
//
//  Created by 김진웅 on 1/13/24.
//

import Foundation

final class GPTViewModel {
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
        let messageDTO = UserMessage(content: userInput).convertGPTMessageDTO()
        messages.append(messageDTO)
        
        let requestDTO = GPTRequestDTO(stream: false, messages: messages)
        Task {
            do {
                let responseDTO: GPTResponseDTO = try await serviceProvider.excute(for: requestDTO)
                Task { @MainActor in
                    if let messageDTO = responseDTO.choices.first?.message {
                        messages.append(messageDTO)
                    }
                }
            } catch {
                // TODO:  에러 처리
            }
        }
    }
}
