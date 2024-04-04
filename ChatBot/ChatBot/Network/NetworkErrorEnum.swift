//
//  NetworkErrorEnum.swift
//  ChatBot
//
//  Created by 권태호 on 04/04/2024.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case connectionError
    case JSONParsingError
    case decodingError
    case serverError
    case dataNotFound
    
    var errorDescription: String {
        switch self {
        case .urlError:
            return "URL 형식이 잘못되었거나 존재하지 않습니다."
        case .connectionError:
            return "인터넷 연결에 문제가 있습니다."
        case .JSONParsingError:
            return "제이슨 파싱에러"
        case .decodingError:
            return "데이터 디코딩 중 에러가 발생했습니다."
        case .serverError:
            return "서버에서 에러가 발생했습니다."
        case .dataNotFound:
            return "요청한 데이터를 찾을 수 없습니다."
        }
    }
}
