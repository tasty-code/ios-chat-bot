//
//  Repository.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/26/24.
//

import Foundation

struct ChatRepository {
    private let apiService: APIService = APIService(session: URLSession.shared)
    func requestChatResultData(userMessage: String) async throws -> (Result<ResponseChatDTO, NetworkError>) {
        
        let chat = RequestChatDTO(messages: [
            Message(role: "system", content: "너는 연애고수야"),
            Message(role: "user", content: "\(userMessage)")
        ])
        
        guard
            let urlRequest = NetworkURL.makeURLRequest(type: .chatGPT, chat: chat, httpMethod: .post)
        else {
            return .failure(.invalidURLRequestError)
        }
        
        let result = try await apiService.fetchData(with: urlRequest)
        switch result {
        case .success(let success):
            return handleDecodedData(data: success)
        case .failure(let failure):
            return .failure(failure)
        }
    }
}

private extension ChatRepository {
    func handleDecodedData<T: Decodable>(data: Data?) -> (Result<T, NetworkError>) {
        guard
            let data = data
        else {
            return .failure(.noDataError)
        }
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(.decodingError)
        }
    }
}
