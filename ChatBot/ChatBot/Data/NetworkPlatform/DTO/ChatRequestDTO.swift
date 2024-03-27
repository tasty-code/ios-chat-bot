//
//  ChatRequestDTO.swift
//  ChatBot
//
//  Created by ㅣ on 3/26/24.
//

import Foundation

struct ChatRequestDTO: Codable {
    let model: String
    let messages: [ChatMessageDTO]
}

struct ChatMessageDTO: Codable {
    let role: String
    let content: String
}
