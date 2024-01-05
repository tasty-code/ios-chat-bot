//
//  HTTPPublishable.swift
//  ChatBot
//
//  Created by 김준성 on 1/4/24.
//

import Combine
import Foundation

protocol HTTPPublishable {
    func publish(urlRequest: URLRequest) -> AnyPublisher<Data, Error>
}

extension URLSession: HTTPPublishable {
    func publish(urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
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
                    return HTTPError.unknownError(description: error.localizedDescription)
                }
                
                return networkException
            }
            .eraseToAnyPublisher()
    }
}
