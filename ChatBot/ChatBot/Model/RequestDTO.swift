//
//  RequestDTO.swift
//  ChatBot
//
//  Created by 권태호 on 01/04/2024.
//

import Foundation

struct RequestDTO: Encodable {
    var model: GPTModel
    let messages: [RequestMessageModel]
    
    enum CodingKeys: String, CodingKey {
        case model
        case messages
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(model, forKey: .model)
        try container.encode(messages, forKey: .messages)
    }
}

enum GPTModel: String, Encodable {
    case gpt3Turbo0125 = "gpt-3.5-turbo-0125"
    case gpt3Turbo = "gpt-3.5-turbo"
    case gpt3Turbo1106 = "gpt-3.5-turbo-1106"
    
}

