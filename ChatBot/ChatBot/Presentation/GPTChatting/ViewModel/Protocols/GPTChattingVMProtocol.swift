//
//  GPTChattingVMProtocol.swift
//  ChatBot
//
//  Created by 김준성 on 1/11/24.
//

import Combine

protocol GPTChattingVMProtocol: ViewModelable
where Input == GPTChatRoomInput, Output == GPTChatRoomOutput { }

struct GPTChatRoomInput {
    let fetchChattings: AnyPublisher<Void, Never>?
    let sendComment: AnyPublisher<String?, Never>?
    let storeChattings: AnyPublisher<Void, Never>?
}

enum GPTChatRoomOutput {
    case success(messages: [Model.GPTMessage], indexToUpdate: Int)
    case failure(Error)
}
