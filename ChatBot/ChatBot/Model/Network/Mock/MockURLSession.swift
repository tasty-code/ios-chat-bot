//
//  MockURLSession.swift
//  ChatBot
//
//  Created by 강창현 on 4/3/24.
//

import Foundation
import Combine

final class MockURLSession: URLSessionProtocol {
    typealias Response = AnyPublisher<(Data, URLResponse), NetworkError>
    
    private let response: Response
    
    init(response: Response) {
        self.response = response
    }
    
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<Data, NetworkError> {
        return response
            .tryMap { (data: Data, response: URLResponse) in
                try self.handleHTTPResponse(data: data, httpResponse: response)
            }
            .mapError { error in
                guard
                    let networkError = error as? NetworkError
                else {
                    return NetworkError.networkError(error)
                }
                return networkError
            }
            .eraseToAnyPublisher()
    }
    
    func handleHTTPResponse(data: Data, httpResponse: URLResponse) throws -> Data {
        guard let httpResponse = httpResponse as? HTTPURLResponse else {
            throw NetworkError.unknownError
        }
        switch httpResponse.statusCode {
        case 300..<400:
            throw NetworkError.redirectionError
        case 400..<500:
            throw NetworkError.clientError
        case 500..<600:
            throw NetworkError.serverError
        default:
            return data
        }
    }
}
