//
//  GPTMessagable.swift
//  ChatBot
//
//  Created by 김준성 on 1/2/24.
//

protocol GPTMessagable {
    var role: Model.GPTMessageRole { get }
    var content: String? { get }
    
    init(requestMessage: Model.GPTMessage)
    
    func asRequestMessage() -> Model.GPTMessage
}

extension Model {
    enum GPTMessageRole: String, Codable {
        case system = "system"
        case user = "user"
        case assistant = "assistant"
        case tool = "tool"
        case waiting
    }
}
