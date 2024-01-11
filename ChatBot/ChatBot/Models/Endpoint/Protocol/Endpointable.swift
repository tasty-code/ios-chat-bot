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
    var httpMethod: HTTPMethods { get }
    var httpHeader: [String: String]? { get }
    var httpBody: Encodable { get }
    var encoder: ContentEncoder { get }
    
    func generateRequest() -> URLRequest
}

extension Endpointable {
    
    var encoder: ContentEncoder { ContentEncoder() }
    
    func generateRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.description
        request.allHTTPHeaderFields = httpHeader
        request.httpBody = encoder.transformData(httpBody)
        
        return request
    }
}
