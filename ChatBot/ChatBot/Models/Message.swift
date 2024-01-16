//
//  Message.swift
//  ChatBot
//
//  Created by Janine on 1/4/24.
//

import Foundation

struct Message: Codable {
    let role: ChatType
    let content: String
}
