//
//  ChatRequestDTO.swift
//  ChatBot
//
//  Created by ㅣ on 3/26/24.
//

import Foundation

struct ChatRequestDTO: Encodable {
    let model: String = "gpt-3.5-turbo-1106"
    let messages: [ChatMessageDTO]
    let stream: Bool = false
}
