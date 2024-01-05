//
//  APIRequestable.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/05.
//

import Foundation

protocol APIRequestable {
    var baseURL: URL? { get }
    var headerFeilds: [String: String] { get }
    var httpMethod: HTTPMethod { get }
    var httpbodyData: Data? { get }
}

extension APIRequestable {
    var httpMethod: HTTPMethod { .post }
}
