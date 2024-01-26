//
//  GPTChatRoomsVMProtocol.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import Combine
import Foundation

typealias GPTChatRoomsVMProtocol = GPTChatRoomsInput & GPTChatRoomsOutput

protocol GPTChatRoomsInput {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidDisappear()
    func createRoom(_ roomName: String?)
    func modifyRoom(_ roomName: String?, for indexPath: IndexPath)
    func deleteRoom(for indexPath: IndexPath)
    func selectRoom(for indexPath: IndexPath)
}

protocol GPTChatRoomsOutput {
    var updateChatRooms: AnyPublisher<[Model.GPTChatRoomDTO], Never> { get }
    var moveToChatting: AnyPublisher<any GPTChattingVMProtocol, Never> { get }
    var moveToPromptSetting: AnyPublisher<any GPTPromptSettingVMProtocol, Never> { get }
    var error: AnyPublisher<Error, Never> { get }
}
