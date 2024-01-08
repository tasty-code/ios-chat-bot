//
//  HTTPError.swift
//  ChatBot
//
//  Created by 김준성 on 1/5/24.
//

import Foundation

extension GPTError {
    enum HTTPError: Error {
        case invalidURL
        case invalidHTTPResponse
        case invalidStatus(statusCode: Int)
        case unknownError(description: String)
    }
}
