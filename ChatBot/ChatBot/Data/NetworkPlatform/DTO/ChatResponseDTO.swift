//
//  ChatResponseDTO.swift
//  ChatBot
//
//  Created by ㅣ on 3/26/24.
//

import Foundation

struct ChatResponseDTO: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let systemFingerprint: String
    let choices: [ChatChoiceDTO]

    enum CodingKeys: String, CodingKey {
        case id, object, created, model, choices
        case systemFingerprint = "system_fingerprint"
    }
}

struct ChatChoiceDTO: Codable {
    let index: Int
    let message: ChatMessageDTO?
}
