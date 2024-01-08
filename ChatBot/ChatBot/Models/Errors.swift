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
    case invaildURL
    case outOfRangeSuccessCode
    case invailAPI
}

enum DecoderError: Error, CustomStringConvertible {
    case failedDeocder
    
    var description: String {
        switch self {
        case .failedDeocder:
            "디코드에 실패하였습니다."
        }
    }
}
