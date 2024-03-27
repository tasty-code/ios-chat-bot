//
//  ChatManager.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/27/24.
//

import Foundation

final class ChatManager {
    var chatData: [ResponseChatDTO]?
    private let chatRepository: ChatRepository = ChatRepository()
}

extension ChatManager {
    func requestChatResultData(userMessage: String) async throws -> ResponseChatDTO {
        let result = try await chatRepository.requestChatResultData(userMessage: userMessage)
        switch result {
        case .success(let data):
            self.chatData?.append(data)
            return data
        case .failure(let error):
            throw error
        }
    }
}
