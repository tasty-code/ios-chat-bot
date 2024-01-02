//
//  DefaultMessage.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

struct DefaultMessage: GPTMessagable {
    let role: GPTMessageRole
    let content: String?
    let name: String?
}
