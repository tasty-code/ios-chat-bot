//
//  UserMessage.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/03.
//

import Foundation

struct UserMessage: GPTMessageable {
    let role: MessageRole = .user
    
    var content: String?
    var name: String?
    
    init(content: String?, name: String? = nil) {
        self.content = content
        self.name = name
    }
    
    func convertGPTMessageDTO() -> GPTMessageDTO {
        return GPTMessageDTO(role: role, content: content, name: name)
    }
}
