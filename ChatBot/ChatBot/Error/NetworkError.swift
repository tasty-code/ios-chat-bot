//
//  NetworkError.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/05.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case unknown
    case invalidURL
    case invalidResponse
    case wrongResponse
    case invalidData
    
    var description: String {
        switch self {
        case .unknown:
            return "에러가 존재합니다"
        case .invalidURL:
            return "유효하지 않은 URL"
        case .invalidResponse:
            return "유효하지 않은 응답"
        case .wrongResponse:
            return "잘못된 응답"
        case .invalidData:
            return "유효하지 않은 데이터"
        }
    }
}
