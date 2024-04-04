//
//  NetworkURL.swift
//  ChatBot
//
//  Created by 강창현 on 4/4/24.
//

import Foundation

enum NetworkURL {
    static func makeURLRequest<T: Encodable>(
        type: APIType,
        httpMethod: HttpMethod<T>
    ) throws -> URLRequest {
        let url = try makeURL(type: type)
        var urlRequest = URLRequest(url: url)
        let (method, body) = httpMethod.type
        urlRequest.httpMethod = method
        urlRequest.allHTTPHeaderFields = type.header
        guard let body else { return urlRequest }
        urlRequest.httpBody = try JSONHandler.handleEncodedData(data: body)
        return urlRequest
    }
    
    private static func makeURL(type: APIType) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = type.host
        urlComponents.path = type.path
        
        guard
            let url = urlComponents.url
        else {
            throw NetworkError.invalidURLError
        }
        return url
    }
}
