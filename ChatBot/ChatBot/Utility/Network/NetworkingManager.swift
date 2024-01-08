//
//  NetworkingManager.swift
//  ChatBot
//
//  Created by 전성수 on 1/5/24.
//

import Foundation

final class NetworkingManager {
    static let shared = NetworkingManager()
    private let decoder = JSONDecoder()
    
    private init() { }
    
    func downloadData<T: Decodable>(request: URLRequest,to type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
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
                print(error)
            }
            
        }.resume()
    }
}
