//
//  APIBaseURLProtocol.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/05.
//

import Foundation

protocol APIBaseURLProtocol {
    var scheme: String { get }
    var host: String { get }
    var path: Path { get }
    var parameters: [String: String]? { get }
    
    func makeURLRequest(httpMethod: HttpMethod, contentType: ContentType) -> URLRequest?
}

extension APIBaseURLProtocol {
    private func makeURL() -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path.value
        components.queryItems = parameters?.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components.url
    }
    
    func makeURLRequest(httpMethod: HttpMethod, contentType: ContentType) -> URLRequest? {
        let apiKey = Bundle.main.apiKey
        
        guard let url = makeURL() else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue(contentType.value, forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = httpMethod.value
        
        return urlRequest
    }
    
}
