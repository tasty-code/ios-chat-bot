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
                error as? NetworkError ?? NetworkError.networkError(error)
            }
            .eraseToAnyPublisher()
    }
}
