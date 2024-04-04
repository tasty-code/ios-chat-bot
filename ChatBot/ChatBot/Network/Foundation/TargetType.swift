//
//  TargetType.swift
//  ChatBot
//
//  Created by EUNJU on 3/28/24.
//

import Foundation

import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParameter { get }
    var header: HeaderType { get }
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        urlRequest = self.makeHeaderForRequest(to: urlRequest)
        
        return try self.makeParameterForRequest(to: urlRequest, with: url)
    }
    
    private func makeHeaderForRequest(to request: URLRequest) -> URLRequest {
        var request = request
        
        switch header {
        case .basic:
            request.headers.add(name: HTTPHeaderField.contentType.rawValue, value: ContentType.json.rawValue)
            request.headers.add(.authorization(bearerToken: Config.openAIAPIKey))
        }
        
        return request
    }
    
    private func makeParameterForRequest(to request: URLRequest, with url: URL) throws -> URLRequest {
        var request = request
        
        switch parameters {
        case .query(let query):
            let queryParams = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            
        case .queryBody(let query, let body):
            let queryParams = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            
            request.httpBody = try JSONEncoder().encode(body)
            
        case .requestBody(let body):
            request.httpBody = try JSONEncoder().encode(body)
            
        case .requestPlain:
            break
        }
        
        return request
    }
}
