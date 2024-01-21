//
//  Repositable.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import Foundation

protocol ChatRoomRepositable {
    func fetchChatRoom() throws
    func fetchChatRoomList() throws -> [Model.GPTChatRoomDTO]
    
    func storeChatRoom(_ chatRoom: Model.GPTChatRoomDTO) throws
    func modifyChatRoom(_ chatRoom: Model.GPTChatRoomDTO) throws
    func removeChatRoom(_ chatRoom: Model.GPTChatRoomDTO) throws
}
