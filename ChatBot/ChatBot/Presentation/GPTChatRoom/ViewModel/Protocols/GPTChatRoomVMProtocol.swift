//
//  GPTChatRoomVMProtocol.swift
//  ChatBot
//
//  Created by 김준성 on 1/11/24.
//

import Combine

protocol GPTChatRoomVMProtocol {
    var chattings: [Model.GPTMessage] { get }
    var chattingsPublisher: Published<[Model.GPTMessage]>.Publisher { get }
    
    func sendComment(_ comment: GPTMessagable)
}
