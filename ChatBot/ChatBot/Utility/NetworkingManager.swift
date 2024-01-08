//
//  NetworkingManager.swift
//  ChatBot
//
//  Created by 전성수 on 1/5/24.
//

import Foundation

final class NetworkingManager {
    static let shared = NetworkingManager()
    
    private init() { }
    
    private func generateRequest(_ httpBody: Data) -> URLRequest? {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return nil
        }
        
        guard let APIKey = Bundle.getAPIKey(for: "openAI_APIKey") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(APIKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = httpBody
        
        return request
    }
    
    func downloadData(_ requestBody: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = generateRequest(requestBody) else {
            return completion(.failure(NetworkingError.requestGenerate))
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error != nil else {
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
            
            completion(.success(data))
        }
    }
}
