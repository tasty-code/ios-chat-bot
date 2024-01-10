//
//  URLSessionProtocol.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/10/24.
//

import Foundation

protocol URLSessionProtocol {}

extension URLSessionProtocol {
    func makeURLSession(config: URLSessionConfiguration?) -> URLSession {
        guard let configuration = config else {
            return URLSession.shared
        }
        return URLSession(configuration: configuration)
    }
}

