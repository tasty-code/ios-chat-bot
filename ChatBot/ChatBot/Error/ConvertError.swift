//
//  ConvertError.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/05.
//

import Foundation

enum ConvertError: Error, CustomStringConvertible {
    case wrongEncodig
    case wrongDecoding
    
    var description: String {
        switch self {
        case .wrongEncodig:
            return "인코딩 실패"
        case .wrongDecoding:
            return "디코딩 실패"
        }
    }
}
