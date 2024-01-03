//
//  ChatRequest.swift
//  ChatBot
//
//  Created by Wonji Ha on 1/2/24.
//

import Foundation

struct ChatRequest: Encodable {
    let model: String
    let message: [Message]
    let stream: Bool?
}
