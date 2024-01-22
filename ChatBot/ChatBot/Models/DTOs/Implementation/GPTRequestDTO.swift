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
    let messages: [GPTMessageDTO]
    
    enum CodingKeys: String, CodingKey {
        case model, stream, messages
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
