//
//  URLSessionMananger.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/10.
//

import Foundation

struct URLSessionManager: URLSessionProtocol {
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
}
