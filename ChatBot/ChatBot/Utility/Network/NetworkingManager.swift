//
//  NetworkingManager.swift
//  ChatBot
//
//  Created by 김경록 on 1/9/24.
//

import Foundation

final class NetworkingManager {
    private let decoder = JSONDecoder()
    private let encoder = Encoder()
    
    static let shared = NetworkingManager()
    private init() {}
    
    private func request(of endpoint: Endpointable) throws -> URLRequest {
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
        
        guard let encodedData = encoder.transformData(endpoint.httpBodyContent) else {
            throw NetworkingError.codableError(whichTranform: "인코딩")
        }
        
        request.httpBody = encodedData
        
        return request
    }
    
    func downloadData<T: Decodable>(endpoint: Endpointable, to type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        do {
            let request = try request(of: endpoint)
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
