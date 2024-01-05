//
//  URLRequest+Extension.swift
//  ChatBot
//
//  Created by 김진웅 on 1/5/24.
//

import Foundation

extension URLRequest {
    init?(apiRequest: APIRequestable) {
        guard let baseURL = apiRequest.baseURL
        else {
            return nil
        }
        self.init(url: baseURL)
        self.allHTTPHeaderFields = apiRequest.headerFeilds
        self.httpMethod = "\(apiRequest.httpMethod)"
        self.httpBody = apiRequest.httpBodyData
    }
}
