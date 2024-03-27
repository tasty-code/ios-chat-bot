//
//  URLSession+Extension.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/26/24.
//

import Foundation

extension URLSession: URLSessionProtocol {
    func requestData(with request: URLRequest, body bodyData: Dictionary<String, String>?) async throws -> (Data, URLResponse) {
        return try await data(for: request)
    }
}
