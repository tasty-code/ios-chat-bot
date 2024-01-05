//
//  AuthorizeHTTPRequest.swift
//  ChatBot
//
//  Created by 김준성 on 1/4/24.
//

import Foundation

extension Network {
    final class AuthorizeHTTPRequest: HTTPDecoratable {
        let httpRequest: HTTPRequestable
        let authorizationType: AuthorizationType
        let authorizationKey: String
        
        init(httpRequest: HTTPRequestable, authorizationType: AuthorizationType, authorizationKey: String) {
            self.httpRequest = httpRequest
            self.authorizationType = authorizationType
            self.authorizationKey = authorizationKey
        }
        
        private func attatchAuthorization(request: inout URLRequest) {
            let key = "Authorization"
            let value = "\(authorizationType) \(authorizationKey)"
            if request.allHTTPHeaderFields == nil {
                request.allHTTPHeaderFields = [key: value]
            } else {
                request.allHTTPHeaderFields?.updateValue(value, forKey: key)
            }
        }
        
        func asGETRequest() -> URLRequest? {
            guard var request = httpRequest.asGETRequest() else {
                return nil
            }
            attatchAuthorization(request: &request)
            return request
        }
        
        func asPOSTRequest(contentType: Network.HTTPContentType, httpBody: Data) -> URLRequest? {
            guard var request = httpRequest.asPOSTRequest(contentType: contentType, httpBody: httpBody) else {
                return nil
            }
            attatchAuthorization(request: &request)
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
