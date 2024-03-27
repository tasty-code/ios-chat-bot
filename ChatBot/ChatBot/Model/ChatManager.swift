//
//  ChatManager.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/27/24.
//

import Foundation

final class ChatManager {
    var chatData: ChatResult?
    private let chatRepository: ChatRepository = ChatRepository()
}

extension ChatManager {
    func requestChatResultData(message: Message) async throws -> ChatResult {
        let result = try await chatRepository.requestChatResultData(message: message)
        switch result {
        case .success(let data):
            self.chatData = data
            return data
        case .failure(let error):
            throw error
        }
    }
}
