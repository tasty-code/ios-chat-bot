//
//  NetworkManagerProtocol.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/05.
//

import Foundation

protocol NetworkManagerProtocol {
    mutating func makeURLRequest(url: URL, httpMethod: HttpMethod, body: Data?)
    func getData (handler: @escaping (Result<Data, NetworkError>) -> Void)
}

enum HttpMethod: String {
    case get
    case post
}
