//
//  Chat.swift
//  ChatBot
//
//  Created by 김예준 on 1/22/24.
//

import Foundation

struct Chat: Hashable {
    let messageID = UUID()
    let sender: Sender
    let message: String
}
