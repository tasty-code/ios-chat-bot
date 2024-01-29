//
//  GPTChatViewModel.swift
//  ChatBot
//
//  Created by 김진웅 on 1/13/24.
//

import Foundation

final class GPTChatViewModel {
    var didMessagesAppend: (([ChatMessage]) -> Void)?
    
    private let serviceProvider: ServiceProvidable
    private let dataHandler: MessageDataHandler
    
    private var currentRoom: ChatRoom?
    private var messages: [ChatMessage] = [] {
        didSet {
            didMessagesAppend?(messages)
        }
    }
    
    init(serviceProvider: ServiceProvidable, dataHandler: MessageDataHandler, currentRoom: ChatRoom? = nil) {
        self.serviceProvider = serviceProvider
        self.dataHandler = dataHandler
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
    
    func fetchMessages() {
        guard let currentRoom = currentRoom else { return }
        messages = dataHandler.fetchChats(at: currentRoom)
    }
    
    private func addResponseMessage(_ chatMessage: ChatMessage) {
        Task { @MainActor in
            messages[messages.count - 1] = chatMessage
            saveMessages()
        }
    }
    
    private func saveMessages() {
        guard let title = messages.first?.content else { return }
        if currentRoom == nil {
            currentRoom = ChatRoom(title: title)
        }
        guard let currentRoom = currentRoom else { return }
        do {
            try dataHandler.saveChat(at: currentRoom, with: messages)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
