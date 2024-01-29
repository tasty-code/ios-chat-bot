//
//  GPTRequestDTO.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/03.
//

import Foundation

struct GPTRequestDTO: RequestDTOEncodable {
    let model: String = "\(GPTModel.basic)"
    let stream: Bool
    let messages: [ChatMessage]
    
    enum CodingKeys: String, CodingKey {
        case model, stream, messages
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(model, forKey: .model)
        try container.encode(stream, forKey: .stream)
        let messageDTOs = messages.map { $0.toMessageDTO() }
        try container.encode(messageDTOs, forKey: .messages)
    }
}

extension GPTRequestDTO {
    enum GPTModel: CustomStringConvertible {
        case basic
        
        var description: String {
            switch self {
            case .basic:
                return "gpt-3.5-turbo-1106"
            }
        }
    }
}
