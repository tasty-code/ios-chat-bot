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
        case unknownError(error: Error)
    }
}

extension GPTError.HTTPError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .invalidHTTPResponse:
            return "HTTP 통신에 실패했습니다."
        case .invalidStatus(let statusCode):
            return "응답코드가 잘못됐습니다. \(statusCode)"
        case .unknownError(let error):
            return "알 수 없는 에러가 발생했습니다.\n\(error.localizedDescription)"
        }
    }
}
