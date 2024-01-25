//
//  GPTChatViewModel.swift
//  ChatBot
//
//  Created by 김진웅 on 1/13/24.
//

import Foundation

final class GPTChatViewModel {
    private let serviceProvider: ServiceProvidable
    
    private var currentRoom: ChatRoom?
    private var messages: [ChatMessage] = [] {
        didSet {
            didMessagesAppend?(messages)
        }
    }
    
    var didMessagesAppend: (([ChatMessage]) -> Void)?
    
    init(serviceProvider: ServiceProvidable, currentRoom: ChatRoom? = nil) {
        self.serviceProvider = serviceProvider
        self.currentRoom = currentRoom
    }
    
    func fetch(userInput: String) {
        let userMessageDTO = UserMessage(content: userInput).toChatMessage()
        messages.append(userMessageDTO)
        let requestDTO = GPTRequestDTO(stream: false, messages: messages)
        
        let assistantMessageDTO = AssistantMessage(content: nil).toChatMessage()
        messages.append(assistantMessageDTO)
        
        Task {
            do {
                let responseDTO: GPTResponseDTO = try await serviceProvider.excute(for: GPTEndPoint.chatbot(body: requestDTO))
                if let messageDTO = responseDTO.choices.first?.message {
                    addResponseMessage(messageDTO.toChatMessage())
                }
            } catch {
                let assistantMessageDTO = AssistantMessage(content: "\(error)").toChatMessage()
                addResponseMessage(assistantMessageDTO)
            }
        }
    }
    
    private func addResponseMessage(_ chatMessage: ChatMessage) {
        Task { @MainActor in
            messages[messages.count - 1] = chatMessage
        }
    }
}
