//
//  GPTChatRoomsVMProtocol.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import Combine
import Foundation

protocol GPTChatRoomsVMProtocol: ViewModelable
where Input == GPTChatRoomsInput, Output == GPTChatRoomsOutput { }

struct GPTChatRoomsInput {
    let fetchRooms: AnyPublisher<Void, Never>
    let createRoom: AnyPublisher<String, Never>
    let modifyRoom: AnyPublisher<(Model.GPTChatRoomDTO, IndexPath), Never>
    let deleteRoom: AnyPublisher<(Model.GPTChatRoomDTO, IndexPath), Never>
    let selectRoom: AnyPublisher<(Model.GPTChatRoomDTO, IndexPath), Never>
}

enum GPTChatRoomsOutput {
    case success(rooms: [Model.GPTChatRoomDTO])
    case failure(error: Error)
}
