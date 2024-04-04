//
//  NetworkService.swift
//  ChatBot
//
//  Created by 강창현 on 4/3/24.
//

import Foundation
import Combine

struct NetworkService {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchChatBotResponse<T:Encodable>(
        type: APIType,
        httpMethod: HttpMethod<T>
    ) -> AnyPublisher<ResponseModel, NetworkError> {
        do {
            let urlRequest = try NetworkURL.makeURLRequest(type: type, httpMethod: httpMethod)
            return session.dataTaskPublisher(for: urlRequest)
                .tryMap { data -> ResponseModel in
                    try JSONHandler.handleDecodedData(data: data)
                }
                .mapError { error in
                    error as? NetworkError ?? NetworkError.networkError(error)
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.requestFailError).eraseToAnyPublisher()
        }
    }
}
