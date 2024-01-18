//
//  GPTChatRoomVMProtocol.swift
//  ChatBot
//
//  Created by 김준성 on 1/11/24.
//

import Combine

protocol GPTChatRoomVMProtocol: ViewModelable
where Input == GPTChatRoomInput, Output == GPTChatRoomOutput { }

struct GPTChatRoomInput {
    let sendingComment: AnyPublisher<String?, Never>
}

enum GPTChatRoomOutput {
    case success(messages: [Model.GPTMessage], indexToUpdate: Int)
    case failure(Error)
}
