//
//  NetworkBuilderProtocol.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/05.
//

import Foundation

protocol NetworkBuilderProtocol {
    var method: HttpMethod { get }
    var path: String { get }
    var header: [String: String] { get throws }
    var body: Data? {get}
}

extension NetworkBuilderProtocol {
    func makeRequest(builder: NetworkBuilderProtocol) -> URLRequest? {
        
        let baseUrl = BaseURL.openAiUrl
        guard let url = URL(string: baseUrl + builder.path) else { return nil }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = builder.method.rawValue
        do {
            try builder.header.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            request.httpBody = builder.body
            
            return request
        } catch {
            return nil
        }
    }
}
