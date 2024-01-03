//
//  ChatRequest.swift
//  ChatBot
//
//  Created by Wonji Ha on 1/2/24.
//

import Foundation

struct ChatRequest: Decodable {
    let model: String
    let message: [Message]
  
}

struct Message: Decodable {
    let role: String
    let content: String
}
