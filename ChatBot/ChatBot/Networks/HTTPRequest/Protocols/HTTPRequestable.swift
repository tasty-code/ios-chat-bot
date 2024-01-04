//
//  HTTPRequestable.swift
//  ChatBot
//
//  Created by 김준성 on 1/4/24.
//

import Foundation

extension Network {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
}

protocol HTTPRequestable {
    var paths: [String]? { get }
    var queryStrings: [String: CustomStringConvertible]? { get }
    var httpMethod: Network.HTTPMethod { get }
    
    func asURLRequest(urlString: String) -> URLRequest?
}

extension HTTPRequestable {
    var paths: [String]? { nil }
    var queryStrings: [String: CustomStringConvertible]? { nil }
    var httpMethod: Network.HTTPMethod { .get }
    
    func asURLRequest(urlString: String) -> URLRequest? {
        guard var components = URLComponents(string: urlString) else {
            return nil
        }
        
        if let paths = paths {
            components.path = "/\(paths.joined(separator: "/"))/"
        }
        
        if let queryStrings = queryStrings {
            components.queryItems = queryStrings.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }
    
}
