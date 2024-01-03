//
//  CommonDTO.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/03.
//

import Foundation

struct Message: Decodable {
    let role: String
    let content: String
    
    enum Role {
        case system
        case user
        case assistant
    }
}


