//
//  RequestGenerator.swift
//  ChatBot
//
//  Created by 전성수 on 1/8/24.
//

import Foundation

struct RequestGenerator {
    
    func generateRequest(_ endpoint: Endpointable) -> URLRequest? {
        guard let url = endpoint.url else {
            return nil
        }
        
        guard let APIKey = endpoint.apiKey else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.description
        request.setValue(endpoint.contentType?.description, forHTTPHeaderField: "Content-Type")
        
        request.setValue("Bearer \(APIKey)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = endpoint.httpBody
        
        return request
    }
}
