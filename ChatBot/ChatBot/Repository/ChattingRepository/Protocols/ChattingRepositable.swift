//
//  ChattingRepositable.swift
//  ChatBot
//
//  Created by 김준성 on 1/21/24.
//

import Foundation

protocol ChattingRepositable {
    func fetchChattings(for chatRoomDTO: Model.GPTChatRoomDTO) throws -> [Model.GPTMessage]
    func storeChattings(_ chattings: [Model.GPTMessage], for chatRoomDTO: Model.GPTChatRoomDTO) throws
}
