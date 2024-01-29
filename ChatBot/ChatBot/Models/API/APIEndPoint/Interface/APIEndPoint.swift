//
//  APIEndPoint.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/05.
//

import Foundation

protocol APIEndPoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headerFields: [String: String]? { get throws }
    var encodableBody: Encodable? { get }
    
    func makeURLRequest(with encoder: DataEncodable) throws -> URLRequest
}

extension APIEndPoint {
    func makeURLRequest(with encoder: DataEncodable) throws -> URLRequest {
        let url = try self.makeBaseURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "\(self.httpMethod)"
        urlRequest.allHTTPHeaderFields = try self.headerFields
        if let encodableBody = self.encodableBody {
            urlRequest.httpBody = try encoder.encode(from: encodableBody)
        }
        return urlRequest
    }
    
    private func makeBaseURL() throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.path = self.path
        guard let url = urlComponents.url
        else {
            throw APIError.badURL
        }
        return url
    }
}
