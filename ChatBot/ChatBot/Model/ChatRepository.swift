//
//  Repository.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/26/24.
//

import Foundation

struct ChatRepository {
    private let apiService: APIService = APIService(session: URLSession.shared)
    func requestChatResultData(message: Message) async throws -> (Result<ChatResult, NetworkError>) {
        guard
            let urlRequest = NetworkURL.makeURLRequest(type: .chatGPT(message), httpMethod: .post)
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
