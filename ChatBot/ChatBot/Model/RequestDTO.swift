//
//  RequestDTO.swift
//  ChatBot
//
//  Created by yujaehong on 3/28/24.
//

import Foundation

struct RequestDTO: Codable {
    let model: GPTModel
    let stream: Bool
    let messages: [MessageDTO]
}

enum GPTModel: String, Codable {
    case main = "gpt-3.5-turbo-1106"
}
