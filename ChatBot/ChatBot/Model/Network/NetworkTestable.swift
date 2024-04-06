//
//  NetworkTestable.swift
//  ChatBot
//
//  Created by 강창현 on 4/3/24.
//

import Foundation
import Combine

protocol NetworkTestable {
    func setMockSession(session: URLSessionProtocol) -> NetworkService
    func makeMockURLSession(fileName: String, statusCode: Int) throws -> URLSessionProtocol
}

extension NetworkTestable {
    func setMockSession(session: URLSessionProtocol) -> NetworkService {
        return NetworkService(session: session)
    }
    
    func makeMockURLSession(fileName: String, statusCode: Int) throws -> URLSessionProtocol {
            let data: Data = JSONHandler.load(fileName: fileName)!
            let httpResponse = HTTPURLResponse(
                url: URL(string: "www.naver.com")!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )! as URLResponse
        let response = Just((data, httpResponse))
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
        return MockURLSession(response: response)
    }
}
