//
//  NetworkError.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/08.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case notFoundAPIKey
    case badURL
    case failedEncoding
    case failedDecoding
    case failedResponseCasting
    case responseError(status: Int)
    
    var description: String {
        switch self {
        case .notFoundAPIKey:
            return "API KEY가 없습니다. 확인해 주세요."
        case .badURL:
            return "URL을 확인해주세요."
        case .failedEncoding:
            return "인코딩에 실패했습니다. \n 다시 시도해 주세요."
        case .failedDecoding:
            return "디코딩에 실패했습니다. \n 다시 시도해 주세요."
        case .failedResponseCasting:
            return "알 수 없는 오류가 발생하였습니다. \n 다시 시도해 주세요."
        case .responseError(let status):
            return "클라이언트 에러 발생: \(status)"
        }
    }
}
