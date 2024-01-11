//
//  NetworkManager.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/5/24.
//

import Foundation
 
final class NetworkManager {
    let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetch(builder: NetworkBuilderProtocol, completion: @escaping (Result<ResponseData, NetworkError>) -> Void) {
    
        guard let request = builder.makeRequest(builder: builder) else {
            return completion(.failure(.invalidHeader))
        }
        
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
    }
}


