//
//  NetworkManager.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/09.
//

import Foundation

final class NetworkManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData(with urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: urlRequest, delegate: nil)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode
        else {
            throw NetworkError.failedResponseCasting
        }
        
        guard (200..<300).contains(statusCode)
        else {
            throw NetworkError.responseError(status: statusCode)
        }
        
        return data
    }
}
