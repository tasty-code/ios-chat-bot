//
//  NetworkError.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/05.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case invalidApiKey
    case invalidBaseUrl
    case faliedDecoding
    case failedEncoding
    case invalidHeader
}
