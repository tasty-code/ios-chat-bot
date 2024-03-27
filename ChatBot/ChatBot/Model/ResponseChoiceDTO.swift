//
//  Choice.swift
//  ChatBot
//
//  Created by Matthew on 3/27/24.
//

import Foundation

struct ResponseChoiceDTO: Decodable {
    let index: Int
    let message: Message
    let logprobs: JSONNull?
    let finishReason: String

    enum CodingKeys: String, CodingKey {
        case index
        case message
        case logprobs
        case finishReason = "finish_reason"
    }
}
