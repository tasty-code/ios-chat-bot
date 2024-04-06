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
    
  private var response: Response? = {
    let data: Data = JSONHandler.load(fileName: "MockData")!
    let httpResponse = HTTPURLResponse(
        url: URL(string: "www.naver.com")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )! as URLResponse
    let response = Just((data, httpResponse))
        .setFailureType(to: NetworkError.self)
        .eraseToAnyPublisher()
    return response
  }()
    
    init(response: Response? = nil) {
      self.response = response
    }
  
  func makeMockResponse(fileName: String, statusCode: Int) -> Response {
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
      return response
  }
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<Data, NetworkError> {
      guard let response else { return Empty().eraseToAnyPublisher() }
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
