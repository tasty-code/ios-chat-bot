//
//  NetworkManager.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/5/24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init () {}

    func makeRequest(builder: NetworkBuilderProtocol) throws -> URLRequest? {
        
        let baseUrl = BaseURL.openAi
        guard let url = URL(string: baseUrl + builder.path) else { return nil }
      
        var request = URLRequest(url: url)
        
        if builder.method == "POST" {
            request.httpMethod = builder.method
            builder.header.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            request.httpBody = builder.body
        }
        
        return request
    }
    
    func fetch(builder: NetworkBuilderProtocol, completion: @escaping (Result<ResponseData, NetworkError>) -> Void) {
        
        do {
            guard let request = try makeRequest(builder: builder) else { return }
            let urlSession = URLSession.shared
            
            urlSession.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return completion(.failure(.invalidResponse))
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(ResponseData.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.faliedDecoding))
                }
            }
            .resume()
        } catch {
            
        }
    }
}
