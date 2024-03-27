//
//  ChatData.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/26/24.
//

import Foundation

struct RequestChatDTO: Encodable {
    let model: String = "gpt-3.5-turbo-1106"
    var messages: [Message]
}
