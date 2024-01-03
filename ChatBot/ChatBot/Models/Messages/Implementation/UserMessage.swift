//
//  UserMessage.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/03.
//

import Foundation

struct UserMessage: GPTMessageable {
    let role: MessageRole
    
    var content: String?
    var name: String?
    
    init(content: String?, name: String?) {
        self.role = .user
        self.content = content
        self.name = name
    }
    
    func converGPTMessageDTO() -> GPTMessageDTO {
        return GPTMessageDTO(role: "\(role)", content: content, name: name)
    }
}
