//
//  RequestModel.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/03.
//

import Foundation

struct RequestModel: Encodable {
    let model: String
    let messages: [Message]
    let stream = false
}
