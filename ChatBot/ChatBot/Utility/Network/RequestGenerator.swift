//
//  RequestGenerator.swift
//  ChatBot
//
//  Created by 전성수 on 1/8/24.
//

import Foundation

struct RequestGenerator {
    
    func generateRequest(_ endpoint: Endpointable) -> URLRequest? {
        var request = URLRequest(url: endpoint.url)
        if let header = endpoint.httpHeader {
            for (field, value) in header {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        request.httpMethod = endpoint.httpMethod.description
        request.httpBody = endpoint.httpBody
        
        return request
    }
}

