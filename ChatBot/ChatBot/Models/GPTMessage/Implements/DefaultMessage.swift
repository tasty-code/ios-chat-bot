//
//  DefaultMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

struct DefaultMessage: GPTMessagable {
    var role: GPTMessageRole
    var content: String?
    var name: String?
}
