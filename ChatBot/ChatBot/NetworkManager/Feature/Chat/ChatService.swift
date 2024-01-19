//
//  ChatService.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/05.
//

import Foundation

final class ChatService: ChatServiceProtocol {
    
    func sendChats(chats: [ChatBubble], completion: @escaping (Result<ResponseData, Error>) -> Void) throws {
        var messages: [Message] = []
        for chat in chats {
            messages.append(chat.message)
        }
        messages.removeLast()
        
        let requestData = RequestData(model: Gpt.model, messages: messages)
        
        guard let encodedData = try? JSONEncoder().encode(requestData) else {
            throw NetworkError.failedEncoding
        }
        
        let builder = ChatSendMessageBuilder(body: encodedData)

        NetworkManager().fetch(builder: builder) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
