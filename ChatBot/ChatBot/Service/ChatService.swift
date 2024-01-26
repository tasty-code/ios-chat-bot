//
//  ChatService.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/15.
//

import Foundation

final class ChatService {
    private let url: APIBaseURLProtocol
    private let networkManager: NetworkManager
    private var chatRecord: [Message] = []
    
    init(url: APIBaseURLProtocol, httpMethod: HttpMethod, contentType: ContentType) {
        self.url = url
        self.networkManager = NetworkManager(urlRequest: url.makeURLRequest(httpMethod: httpMethod, contentType: contentType))
    }
}

extension ChatService {
    func addRecord(messages: [Message]) -> [Message] {
        for message in messages {
            chatRecord.append(message)
        }
        return chatRecord
    }
    
    func sendRequestDTO() async -> [Message] {
        let request = RequestModel(messages: chatRecord)
        do {
            let response = try await networkManager.requestData(inputData: request, type: ResponseModel.self).choices[0].message
            chatRecord[chatRecord.count - 1] = response
        } catch {
            chatRecord[chatRecord.count - 1] = Message(role: .assistant, content: error.localizedDescription)
        }
        return chatRecord
    }
}
