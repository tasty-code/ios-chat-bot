//
//  MockHTTPPublisher.swift
//  ChatBotTests
//
//  Created by 김준성 on 1/9/24.
//

import Combine
import Foundation

@testable import ChatBot

final class MockHTTPPublisher: HTTPPublishable {
    func publish(urlRequest: URLRequest) -> AnyPublisher<Data, ChatBot.GPTError.HTTPError> {
        guard let data = try? JSONFetcher.fileData(of: urlRequest.url!.absoluteURL) else {
            return Fail(error: .unknownError(description: "Data를 찾을 수 없음."))
                .eraseToAnyPublisher()
        }
        
        return Just(data)
            .setFailureType(to: ChatBot.GPTError.HTTPError.self)
            .eraseToAnyPublisher()
    }
}
