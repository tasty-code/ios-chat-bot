//
//  ChatService.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/05.
//

import Foundation

final class ChatService: ChatServiceProtocol {
    
    func sendMessage(text: String, completion: @escaping (Result<ResponseData, Error>) -> Void) throws {
        
        let requestData = RequestData(model: Gpt.model, messages: [Message(role: "user", content: text)])
        
        guard let encodedData = try? JSONEncoder().encode(requestData) else {
            throw NetworkError.failedEncoding
        }
        
        let builder = ChatSendMessageBuilder(body: encodedData)
        
        NetworkManager.shared.fetch(builder: builder) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
