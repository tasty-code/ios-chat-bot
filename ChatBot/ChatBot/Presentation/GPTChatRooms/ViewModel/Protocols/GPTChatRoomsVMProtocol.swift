//
//  GPTChatRoomsVMProtocol.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import Combine
import Foundation

typealias GPTChatRoomsVMProtocol = GPTChatRoomsInputProtocol & GPTChatRoomsOutputProtocol

protocol GPTChatRoomsInputProtocol {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidDisappear()
    func createRoom(_ roomName: String?)
    func modifyRoom(_ roomName: String?, for indexPath: IndexPath)
    func deleteRoom(for indexPath: IndexPath)
    func selectRoom(for indexPath: IndexPath)
}

protocol GPTChatRoomsOutputProtocol {
    var output: AnyPublisher<GPTChatRoomsOutput, Never> { get }
}

enum GPTChatRoomsOutput {
    case updateChatRooms(Result<[Model.GPTChatRoomDTO], Error>)
    case moveToChatRoom(Result<any GPTChattingVMProtocol, Error>)
}
