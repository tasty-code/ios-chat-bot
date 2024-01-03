//
//  Message.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/3/24.
//

import Foundation

// MARK: - Message
struct Message: Decodable {
    let role, content: String
}
