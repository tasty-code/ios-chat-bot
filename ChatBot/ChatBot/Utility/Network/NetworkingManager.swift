//
//  NetworkingManager.swift
//  ChatBot
//
//  Created by 김경록 on 1/9/24.
//

import Foundation

final class NetworkingManager {
    static let shared = NetworkingManager()
    private let decoder = JSONDecoder()
    private let encoder = Encoder()
    
    private init() {}
    
    private func request(_ endpoint: Endpointable) throws -> URLRequest {
        guard let url = endpoint.url else {
            throw NetworkingError.unknownURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        
        for (headerField, value) in endpoint.httpHeader {
            request.setValue(value, forHTTPHeaderField: headerField)
        }
        
        if endpoint.useAuthorization {
            guard let accessKey = endpoint.accessKey else {
                throw NetworkingError.accessKey
            }
            request.setValue("Bearer \(accessKey)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try encoder.transformData(endpoint.httpBodyContent)
        
        return request
    }
    
    func downloadData<T: Decodable>(endpoint: Endpointable, to type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        do {
            let request = try request(endpoint)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return completion(.failure(NetworkingError.taskingError))
                }
                
                guard let response = response as? HTTPURLResponse else {
                    return completion(.failure(NetworkingError.unknown))
                }
                
                guard (200..<300).contains(response.statusCode) else {
                    return completion(.failure(NetworkingError.networkError(statusCode: response.statusCode)))
                }
                
                guard let data = data else {
                    return completion(.failure(NetworkingError.corruptedData))
                }
                
                do {
                    let model = try self.decoder.decode(type.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(NetworkingError.codableError(whichTranform: "\(type) 디코딩 실패")))
                }
                
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
