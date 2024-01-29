//
//  ChatService.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/15.
//

import Foundation

final class ServiceProvider {
    private let chatRepository = ChatRepository()
    weak var delegate: UpdateUIDelegate?

    init(delegate: UpdateUIDelegate? = nil) {
        self.delegate = delegate
    }
    
    func sendRequestDTO(message: String) async -> [Message] {
        let message = [Message(role: .user, content: message), 
                       Message(role: .assistant, content: "")]
        let request = RequestModel(messages: message)
        let chatRecord = chatRepository.addChatRecord(request: request)
        delegate?.updateUI(message: chatRecord)
        
        let response = await chatRepository.sendRequest(request: request)
 
        return response
    }
}
