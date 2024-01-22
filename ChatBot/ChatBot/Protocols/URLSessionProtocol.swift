//
//  URLSessionProtocol.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/09.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}
