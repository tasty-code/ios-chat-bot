//
//  GPTMessagable.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

protocol GPTMessagable {
    var role: GPTMessageRole { get }
    var content: String? { get }
    
    init(requestMessage: GPTMessage)
    
    func asRequestMessage() -> GPTMessage
}

enum GPTMessageRole: String, Codable {
    case system = "system"
    case user = "user"
    case assistant = "assistant"
    case tool = "tool"
}
