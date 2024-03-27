//
//  ChatData.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/26/24.
//

import Foundation

struct ChatResult: Codable {
    let model: String
    let messages: [Message]
}
