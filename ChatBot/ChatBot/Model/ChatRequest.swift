//
//  ChatRequest.swift
//  ChatBot
//
//  Created by yujaehong on 3/28/24.
//

import Foundation

struct ChatRequest: Codable {
    var model: String = "gpt-3.5-turbo-1106"
    var stream: Bool = false
    let messages: [Message]
}


