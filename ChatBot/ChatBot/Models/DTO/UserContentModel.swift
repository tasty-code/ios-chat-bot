//
//  UserContentModel.swift
//  ChatBot
//
//  Created by 전성수 on 1/3/24.
//

import Foundation

// MARK: - UserContentModel
struct UserContentModel: Encodable  {
    let model: String = "gpt-3.5-turbo"
    let stream: Bool = false
    var messages: [Message]
}



