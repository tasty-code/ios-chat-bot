//
//  NetworkingError.swift
//  ChatBot
//
//  Created by 전성수 on 1/8/24.
//

import Foundation

enum NetworkingError: Error, CustomDebugStringConvertible {
    case unknown
    case requestGenerate
    case taskingError
    case networkError(statusCode: Int)
    case corruptedData
    case codableError(whichTranform: String)
    
    var debugDescription: String {
        switch self {
        case .unknown: "알 수 없는 에러입니다."
        case .requestGenerate: "URLReqeust 생성을 실패했습니다."
        case .taskingError: "DataTask 작업 중 에러가 발생했습니다."
        case .networkError(let statusCode): "통신 에러가 발생했습니다. Code: \(statusCode)"
        case .corruptedData: "손상된 데이터입니다."
        case .codableError(let whichTranform): "데이터를 변환하는데 문제가 생겼습니다.\(whichTranform)"
        }
    }
}
