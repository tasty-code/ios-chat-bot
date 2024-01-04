//
//  ContentHTTPRequest.swift
//  ChatBot
//
//  Created by 김준성 on 1/4/24.
//

import Foundation

extension Network {
    struct ContentHTTPRequest: HTTPDecoratable {
        let httpMethod: Network.HTTPMethod = .post
        let httpRequest: HTTPRequestable
        let contentType: HTTPContentType
        let data: Data?
        
        func asURLRequest(urlString: String) -> URLRequest? {
            var request = httpRequest.asURLRequest(urlString: urlString)
            request?.httpMethod = httpMethod.rawValue
            request?.setValue(contentType.description, forHTTPHeaderField: "Content-Type")
            request?.httpBody = data
            return request
        }
    }
}

extension Network.ContentHTTPRequest {
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
