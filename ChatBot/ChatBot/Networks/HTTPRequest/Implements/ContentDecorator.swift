//
//  GPTHTTPRequest.swift
//  ChatBot
//
//  Created by 김준성 on 1/4/24.
//

import Foundation

extension Network {
    final class ContentDecorator: HTTPDecoratable {
        let httpRequest: HTTPRequestable
        let httpMethod: Network.HTTPMethod = .post
        let headerFields: [String : String]?
        
        init(httpRequest: HTTPRequestable, contentType: Network.HTTPContentType) {
            self.httpRequest = httpRequest
            self.headerFields = ["Content-Type": "\(contentType)"]
        }
        
        func asURLRequest() throws -> URLRequest {
            guard let headerFields = headerFields else {
                throw GPTError.HTTPError.invalidURL
            }
            
            var request = try httpRequest.asURLRequest()
            request.httpMethod = "\(httpMethod)"
            for (key, value) in headerFields {
                request.setValue(value, forHTTPHeaderField: key)
            }
            return request
        }
    }
}
