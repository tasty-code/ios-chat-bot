//
//  URLRequestBuilder.swift
//  ChatBot
//
//  Created by 권태호 on 04/04/2024.
//

import Foundation

struct URLRequestBuilder {
    func makeRequest(url: URL?,
                     for model: GPTModel,
                     APIKey apiKey: String,
                     withMessages messages: [RequestMessageModel]) throws -> URLRequest {
        
        guard let url = url else {
            throw NetworkError.urlError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(APIKeyManager.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestDTO = RequestDTO(model: model, messages: messages)
        
        do {
            let jsonData = try JSONEncoder().encode(requestDTO)
            request.httpBody = jsonData
            printRequestDetails(request)
        } catch {
            throw NetworkError.JSONParsingError
        }
        return request
    }
    
    // MARK: - URLRequest 검증 메서드
   private func printRequestDetails(_ request: URLRequest) {
        print("URL: \(request.url?.absoluteString ?? "Invalid URL")")
        print("HTTP Method: \(request.httpMethod ?? "No HTTP Method")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let httpBody = request.httpBody, let jsonString = String(data: httpBody, encoding: .utf8) {
            print("HTTP Body: \(jsonString)")
        }
    }
}
