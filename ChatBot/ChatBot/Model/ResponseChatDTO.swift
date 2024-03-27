//
//  ResponseChat.swift
//  ChatBot
//
//  Created by Matthew on 3/27/24.
//

import Foundation

// MARK: - ResponseChat
struct ResponseChatDTO: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [ResponseChoiceDTO]
    let usage: Usage
    let systemFingerprint: String

    enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case model
        case choices
        case usage
        case systemFingerprint = "system_fingerprint"
    }
}
