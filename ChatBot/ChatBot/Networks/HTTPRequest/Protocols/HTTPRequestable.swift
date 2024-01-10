//
//  HTTPRequestable.swift
//  ChatBot
//
//  Created by 김준성 on 1/4/24.
//

import Foundation

protocol HTTPRequestable {
    var urlString: String? { get }
    var paths: [String]? { get }
    var queryStrings: [String: CustomStringConvertible]? { get }
    
    var headerFields: [String: String]? { get }
    var httpMethod: Network.HTTPMethod { get }
    
    func configureURL() -> URL?
    func asURLRequest() throws -> URLRequest
}

extension HTTPRequestable {
    var paths: [String]? { nil }
    var queryStrings: [String: CustomStringConvertible]? { nil }
    var headerFields: [String : String]? { nil }
    
    func configureURL() -> URL? {
        guard let urlString = urlString,
              var components = URLComponents(string: urlString) else {
            return nil
        }
        
        if let paths = paths {
            components.path = components.path + "/\(paths.joined(separator: "/"))"
        }
        
        if let queryStrings = queryStrings {
            components.queryItems = queryStrings.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        return components.url
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = configureURL() else {
            throw GPTError.HTTPError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headerFields
        
        return request
    }
}
