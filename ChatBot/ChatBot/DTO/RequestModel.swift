//
//  RequestModel.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/03.
//

import Foundation

struct RequestModel: Encodable {
    let model: String = "gpt-3.5-turbo-1106"
    let messages: [Message]
    let stream = false
}
