//
//  AuthorizeHTTPRequest.swift
//  ChatBot
//
//  Created by 김준성 on 1/4/24.
//

import Foundation

extension Network {
    struct AuthorizeHTTPRequest: HTTPDecoratable {
        let httpRequest: HTTPRequestable
        let authorizationType: AuthorizationType
        let authorizationKey: String
        
        func asURLRequest(urlString: String) -> URLRequest? {
            var request = httpRequest.asURLRequest(urlString: urlString)
            request?.setValue("\(authorizationType) \(authorizationKey)", forHTTPHeaderField: "Authorization")
            return request
        }
    }
}
extension Network.AuthorizeHTTPRequest {
    enum AuthorizationType: CustomStringConvertible {
        case bearer
        
        var description: String {
            switch self {
            case .bearer:
                return "Bearer"
            }
        }
    }
}
