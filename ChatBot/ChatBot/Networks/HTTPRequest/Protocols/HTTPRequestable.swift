//
//  HTTPRequestable.swift
//  ChatBot
//
//  Created by 김준성 on 1/4/24.
//

import Foundation

extension Network {
    enum HTTPContentType: CustomStringConvertible {
        case json
        
        var description: String {
            switch self {
            case .json:
                return "application/json"
            }
        }
    }
}

protocol HTTPRequestable: AnyObject {
    var urlString: String? { get }
    var paths: [String]? { get }
    var queryStrings: [String: CustomStringConvertible]? { get }
    
    func configureURL() -> URL?
    func asGETRequest() -> URLRequest?
    func asPOSTRequest(contentType: Network.HTTPContentType, httpBody: Data) -> URLRequest?
}

extension HTTPRequestable {
    var paths: [String]? { nil }
    var queryStrings: [String: CustomStringConvertible]? { nil }
    
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
    
    func asGETRequest() -> URLRequest? {
        guard let url = configureURL() else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func asPOSTRequest(contentType: Network.HTTPContentType, httpBody: Data) -> URLRequest? {
        var request = asGETRequest()
        request?.httpMethod = "POST"
        request?.setValue("\(contentType)", forHTTPHeaderField: "Content-Type")
        request?.httpBody = httpBody
        return request
    }
}
