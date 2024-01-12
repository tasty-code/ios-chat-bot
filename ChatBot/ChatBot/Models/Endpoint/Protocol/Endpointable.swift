//
//  Endpointable.swift
//  ChatBot
//
//  Created by 김경록 on 1/10/24.
//

import Foundation

protocol Endpointable {
    var url: URL { get }
    var apiKey: String? { get }
    var httpMethod: HTTPMethod { get }
    var httpHeader: [String: String]? { get }
    var httpBody: Encodable { get }
    var encoder: Encoder { get }
    
    func generateRequest() -> URLRequest
}

extension Endpointable {
    
    var encoder: Encoder { Encoder() }
    
    func generateRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.description
        request.allHTTPHeaderFields = httpHeader
        request.httpBody = encoder.transformData(httpBody)
        
        return request
    }
}
