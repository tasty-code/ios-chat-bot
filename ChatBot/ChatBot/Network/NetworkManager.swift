//
//  NetworkManager.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/05.
//

import Foundation

struct NetworkManager: NetworkManagerProtocol {
    private let apiKey = Bundle.main.apiKey
    
    func makeURLRequest(url: URL, httpMethod: HttpMethod) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "\(httpMethod)".uppercased()
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
}
