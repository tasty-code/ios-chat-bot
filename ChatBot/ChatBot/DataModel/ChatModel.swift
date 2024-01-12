//
//  ChatModel.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/12.
//

import Foundation

struct ChatModel: Identifiable, Equatable, Hashable {
    let message: Message
    let created: Int
    let role: Role
    let id: Int
}
