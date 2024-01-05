//
//  NetworkManager.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/05.
//

import Foundation

struct NetworkManager {
    private let apiKey = Bundle.main.apiKey
}

// MARK: - protocol method
extension NetworkManager: NetworkManagerProtocol {
    func makeURLRequest(url: URL, httpMethod: HttpMethod, body: Data?) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "\(httpMethod)".uppercased()
        
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = body
        
        return urlRequest
    }
}
