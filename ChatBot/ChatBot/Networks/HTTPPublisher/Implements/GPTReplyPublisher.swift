//
//  GPTReplyPublisher.swift
//  ChatBot
//
//  Created by 김준성 on 1/5/24.
//

import Foundation
import Combine

extension Network {
    struct GPTReplyPublisher: GPTTypePublishable {
        typealias T = Model.GPTReplyDTO?
        
        let httpPublisher: HTTPPublishable
        let jsonDecoder = JSONDecoder()
        
        func publish(urlRequest: URLRequest, errorHandler: (Error) -> Void) -> AnyPublisher<T, Never> {
            return httpPublisher.publish(urlRequest: urlRequest)
                .tryMap(map)
                .handleEvents(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                })
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        
        func map(_ data: Data) throws -> Model.GPTReplyDTO? {
            try jsonDecoder.decode(T.self, from: data)
        }
    }
}
