//
//  NetworkManager.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/05.
//

import Foundation

final class NetworkManager {
    private let session: URLSession
    private var urlRequest: URLRequest?
    
    init(session: URLSession = URLSession.shared, urlRequest: URLRequest?) {
        self.session = session
        self.urlRequest = urlRequest
    }
}

// MARK: - protocol method
extension NetworkManager: NetworkManagerProtocol {
    func getData(body: Data?) async throws -> Data {
        guard var urlRequest = urlRequest else {
            throw NetworkError.invalidURL
        }
        urlRequest.httpBody = body
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.invalidResponse
        }
        guard (200..<300) ~= statusCode else {
            print(statusCode)
            throw NetworkError.wrongResponse
        }
        
        return data
    }

    func requestData<E: Encodable, D: Decodable>(inputData: E) async throws -> D {
        
        guard let encodedData = JSONConverter.encode(data: inputData) else {
            throw JSONConvertError.wrongEncodig
        }
        
        let responseData = try await getData(body: encodedData)
        
        guard let decodedData = JSONConverter.decode(type: D.self, data: responseData) else {
            throw JSONConvertError.wrongDecoding
        }
        
        return decodedData
    }
}
