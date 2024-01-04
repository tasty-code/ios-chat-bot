//
//  ChatRequestModel.swift
//  ChatBot
//
//  Created by Wonji Ha on 1/2/24.
//

import Foundation

struct ChatRequestModel: Encodable {
    let model: String
    let messages: [Message]
    let stream: Bool?
    let logprobs: Bool?
}
