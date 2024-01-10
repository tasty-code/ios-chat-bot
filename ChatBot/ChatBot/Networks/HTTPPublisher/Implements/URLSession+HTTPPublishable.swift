//
//  URLSession+HTTPPublishable.swift
//  ChatBot
//
//  Created by 김준성 on 1/8/24.
//

import Combine
import Foundation

extension URLSession: HTTPPublishable {
    func publish(urlRequest: URLRequest) -> AnyPublisher<Data, GPTError.HTTPError> {
        typealias HTTPError = GPTError.HTTPError
        
        return self.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) in
                guard let response = response as? HTTPURLResponse else {
                    throw HTTPError.invalidHTTPResponse
                }
                
                if !(200..<300).contains(response.statusCode) {
                    throw HTTPError.invalidStatus(statusCode: response.statusCode)
                }
                
                return data
            }
            .mapError { error in
                guard let networkException = error as? HTTPError else {
                    return HTTPError.unknownError(error: error)
                }
                
                return networkException
            }
            .eraseToAnyPublisher()
    }
}

