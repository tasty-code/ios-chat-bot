//
//  ChatRepository.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/29.
//

import Foundation

final class ChatRepository {
    private let url: APIBaseURLProtocol
    private let networkManager: NetworkManager
    private var chatRecord: [Message] = []
    
    weak var delegate: UpdateUIDelegate?
    
    init() {
        self.url = OpenAIURL(path: .chat)
        self.networkManager = NetworkManager(urlRequest: url.makeURLRequest(httpMethod: .post, contentType: .json))
    }
   
    func addChatRecord(request: RequestModel) -> [Message] {
        for message in request.messages {
            chatRecord.append(message)
        }
        return chatRecord
    }
}

extension ChatRepository: OpenAIRepository {
    typealias D = [Message]
    typealias E = RequestModel

    func sendRequest(request: RequestModel) async -> [Message] {
        let request = RequestModel(messages: chatRecord)
        do {
            let response = try await networkManager.requestData(inputData: request, type: ResponseModel.self)
            
            if response.choices[0].finishReason != FinishReason.stop {
                chatRecord[chatRecord.count - 1] = Message(role: .assistant, content: response.choices[0].finishReason?.rawValue)
            } else {
                chatRecord[chatRecord.count - 1] = response.choices[0].message
            }
        } catch {
            print(error.localizedDescription)
        }
        return chatRecord
    }
}

