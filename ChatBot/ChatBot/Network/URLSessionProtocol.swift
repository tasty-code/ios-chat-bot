//
//  URLSessionProtocol.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/26/24.
//

import Foundation

protocol URLSessionProtocol {
    func requestData(with request: URLRequest) async throws -> (Data, URLResponse)
}

