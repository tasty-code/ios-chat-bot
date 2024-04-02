//
//  ChatRequestModel.swift
//  ChatBot
//
//  Created by EUNJU on 4/1/24.
//

import Foundation

struct ChatRequestModel: Codable {
    let model: String
    let messages: [Message]
}
