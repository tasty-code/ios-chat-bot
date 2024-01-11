//
//  NetworkError.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/08.
//

import Foundation

enum NetworkError: Error {
    case notFoundAPIKey
    case badURL
    case failedEncoding
    case failedDecoding
    case failedResponseCasting
    case responseError(status: Int)
}
