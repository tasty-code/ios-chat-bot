//
//  Entities.swift
//  ChatBot
//
//  Created by ㅣ on 3/26/24.
//

import Foundation

struct ChatResponseEntity {
    let messages: [ChatMessageEntity]
}

struct ChatMessageEntity {
    enum Role {
        case user // 질문
        case assistant // 답변
    }

    let role: Role
    let content: String
}
