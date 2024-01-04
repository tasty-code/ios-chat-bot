//
//  APIRequest.swift
//  ChatBot
//
//  Created by Janine on 1/4/24.
//

import Foundation

struct APIRequest: Encodable {
    let model: String
    let stream: Bool
    let messages: [Message]
}
