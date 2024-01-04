//
//  GPTCommentDTO.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

extension Model {
    struct GPTCommentDTO: Encodable {
        var model: String { "gpt-3.5-turbo-1106" }
        var messages: [GPTMessagable]
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: Self.CodingKeys.self)
            try container.encode(model, forKey: .model)
            try container.encode(messages.map { $0.asRequestMessage() }, forKey: .messages)
        }
    }
}

extension Model.GPTCommentDTO {
    enum CodingKeys: String, CodingKey {
        case model
        case messages
    }
}
