//
//  APIRequestable.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/05.
//

import Foundation

protocol APIRequestable {
    var baseURL: String { get }
    var headerFields: [String: String] { get }
    var httpMethod: HTTPMethod { get }
    var bodyDTO: Encodable? { get }
}

extension APIRequestable {
    var httpMethod: HTTPMethod { .post }
}
