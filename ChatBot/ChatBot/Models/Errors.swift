//
//  Errors.swift
//  ChatBot
//
//  Created by Wonji Ha on 1/5/24.
//

import Foundation

enum APIKeyError: CustomStringConvertible, Error {
    case keyFileNotFound, keyNotFound
    
    var description: String {
        switch self {
        case .keyFileNotFound:
            "키 파일이 없습니다."
        case .keyNotFound:
            "키 파일에 키가 없습니다."
        }
    }
}

enum NetworkError: Error {
    case failedTransformHTTPURLResponse
    case invaildURL
    case invailAPI
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case notAcceptable
    case other4XXError(statusCode: Int)
    case internalSeverError
    case badGateway
    case gatewayTimeout
    case other5XXError(statusCode: Int)
    case anotherStatusError(statusCode: Int)
    
    static func httpError(_ statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 406:
            return .notAcceptable
        case 402, 405, 407..<500:
            return .other4XXError(statusCode: statusCode)
        case 500:
            return .internalSeverError
        case 502:
            return .badGateway
        case 504:
            return .gatewayTimeout
        case 501, 503, 505..<600:
            return .other5XXError(statusCode: statusCode)
        default:
            return .anotherStatusError(statusCode: statusCode)
        }
    }
}

enum DecoderError: Error, CustomStringConvertible {
    case failedDeocde
    
    var description: String {
        switch self {
        case .failedDeocde:
            "디코드에 실패하였습니다."
        }
    }
}

enum MessageSendError: Error, CustomStringConvertible {
    case sendError
    
    var description: String {
        switch self {
        case .sendError:
            "메시지 전송에 실패하였습니다.\n오류내용: "
        }
    }
}
