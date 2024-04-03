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
            let urlRequest = try makeURLRequest(type: type, httpMethod: httpMethod)
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
    
    private func makeURL(type: APIType) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = type.host
        urlComponents.path = type.path
        
        guard
            let url = urlComponents.url
        else {
            throw NetworkError.invalidURLError
        }
        return url
    }
    
    private func makeURLRequest<T: Encodable>(
        type: APIType,
        httpMethod: HttpMethod<T>
    ) throws -> URLRequest {
        let url = try makeURL(type: type)
        var urlRequest = URLRequest(url: url)
        let (method, body) = httpMethod.type
        urlRequest.httpMethod = method
        urlRequest.allHTTPHeaderFields = type.header
        guard let body else { return urlRequest }
        urlRequest.httpBody = try JSONHandler.handleEncodedData(data: body)
        return urlRequest
    }
}
