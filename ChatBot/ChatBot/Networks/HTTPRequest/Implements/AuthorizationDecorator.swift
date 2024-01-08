//
//  AuthorizationDecorator.swift
//  ChatBot
//
//  Created by 김준성 on 1/8/24.
//

import Foundation

extension Network {
    final class AuthorizationDecorator: HTTPDecoratable {
        let httpRequest: HTTPRequestable
        let httpMethod: Network.HTTPMethod = .get
        let headerFields: [String : String]?
        
        init(httpRequest: HTTPRequestable, authorizationType: Network.AuthorizationType, authorizationKey: String) {
            self.httpRequest = httpRequest
            self.headerFields = ["Authorization": "\(authorizationType) \(authorizationKey)"]
        }
        
        func asURLRequest() throws -> URLRequest {
            guard let headerFields = headerFields else {
                throw GPTError.HTTPError.invalidURL
            }
            
            var request = try httpRequest.asURLRequest()
            for (key, value) in headerFields {
                request.setValue(value, forHTTPHeaderField: key)
            }
            return request
        }
    }
}
