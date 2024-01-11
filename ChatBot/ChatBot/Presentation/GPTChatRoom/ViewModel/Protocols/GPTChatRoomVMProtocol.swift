//
//  GPTChatRoomVMProtocol.swift
//  ChatBot
//
//  Created by 김준성 on 1/11/24.
//

import Combine
import Foundation

protocol GPTChatRoomVMProtocol {
    var chattingsPublisher: Published<[GPTMessagable]>.Publisher { get }
    
    func sendComment(_ comment: GPTMessagable)
}
