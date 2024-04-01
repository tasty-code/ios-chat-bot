//
//  RequestDTO.swift
//  ChatBot
//
//  Created by 권태호 on 01/04/2024.
//

import Foundation

struct RequestDTO: Encodable {
    let model: GPTModel
    let message: [RequestMessageModel]
}

enum GPTModel: Encodable {
    case gpt3Turbo0125
    case gpt3Turbo
    case gpt3Turbo1106
    
    func aiModel() -> String {
        switch self {
        case GPTModel.gpt3Turbo0125:
            return "gpt-3.5-turbo-0125"
        case GPTModel.gpt3Turbo:
            return "gpt-3.5-turbo"
        case GPTModel.gpt3Turbo1106:
            return "gpt-3.5-turbo-1106"
        }
    }
}
    
