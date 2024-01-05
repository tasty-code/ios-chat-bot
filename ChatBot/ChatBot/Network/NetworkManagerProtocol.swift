//
//  NetworkManagerProtocol.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/05.
//

import Foundation

protocol NetworkManagerProtocol {
    func makeURLRequest(url: URL, httpMethod: HttpMethod, body: Data?) -> URLRequest
}

enum HttpMethod: String {
    case get
    case post
}
