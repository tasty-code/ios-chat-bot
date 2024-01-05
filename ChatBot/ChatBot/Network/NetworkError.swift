//
//  NetworkError.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/05.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case unknown
    case invalidResponse
    case invalidData
    
    var description: String {
        switch self {
        case .unknown:
            return "알수없는 에러"
        case .invalidResponse:
            return "잘못된 응답"
        case .invalidData:
            return "유효하지 않은 데이터"
        }
    }
}
