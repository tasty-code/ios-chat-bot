//
//  GPTChatRoomsViewModel.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import Combine
import Foundation

final class GPTChatRoomsViewModel: GPTChatRoomsOutput {
    private let chatRoomRepository: ChatRoomRepositable
    
    private let updateChatRoomsSubject = PassthroughSubject<[Model.GPTChatRoomDTO], Never>()
    private let moveToChattingSubject = PassthroughSubject<GPTChattingVMProtocol, Never>()
    private let moveToPromptSettingSubject = PassthroughSubject<GPTPromptSettingVMProtocol, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private var chatRoomList = [Model.GPTChatRoomDTO]()
    
    var updateChatRooms: AnyPublisher<[Model.GPTChatRoomDTO], Never> { updateChatRoomsSubject.eraseToAnyPublisher() }
    var moveToChatting: AnyPublisher<GPTChattingVMProtocol, Never> { moveToChattingSubject.eraseToAnyPublisher() }
    var moveToPromptSetting: AnyPublisher<GPTPromptSettingVMProtocol, Never> { moveToPromptSettingSubject.eraseToAnyPublisher() }
    var error: AnyPublisher<Error, Never> { errorSubject.eraseToAnyPublisher() }
    
    init(chatRoomRepository: ChatRoomRepositable = Repository.CoreDataChatRoomRepository()) {
        self.chatRoomRepository = chatRoomRepository
    }
}

extension GPTChatRoomsViewModel: GPTChatRoomsInput {
    func onViewDidLoad() { }
    
    func onViewWillAppear() {
        fetchChatRooms()
    }
    
    func onViewDidDisappear() { }
    
    func createRoom(_ roomName: String?) {
        guard let roomName = roomName, !roomName.isEmpty else {
            errorSubject.send(GPTError.ChatRoomError.noRoomName)
            return
        }
        
        let chatRoom = Model.GPTChatRoomDTO(title: roomName, recentChatDate: Date())
        handleRooms {
            try chatRoomRepository.storeChatRoom(chatRoom)
            chatRoomList.append(chatRoom)
        }
    }
    
    func modifyRoom(_ roomName: String?, for indexPath: IndexPath) {
        guard let roomName = roomName, !roomName.isEmpty else {
            errorSubject.send(GPTError.ChatRoomError.noRoomName)
            return
        }
        
        let previousChatRoom = chatRoomList[indexPath.item]
        let newChatRoom = Model.GPTChatRoomDTO(id: previousChatRoom.id, title: roomName, recentChatDate: previousChatRoom.recentChatDate)
        handleRooms {
            try chatRoomRepository.modifyChatRoom(newChatRoom)
            chatRoomList[indexPath.item] = newChatRoom
        }
    }
    
    func deleteRoom(for indexPath: IndexPath) {
        let chatRoom = chatRoomList[indexPath.item]
        handleRooms {
            try chatRoomRepository.removeChatRoom(chatRoom)
            chatRoomList.remove(at: indexPath.item)
        }
    }
    
    func selectRoom(for indexPath: IndexPath) {
        let chatRoom = chatRoomList[indexPath.item]
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "CHAT_BOT_API_KEY") as? String else {
            errorSubject.send(GPTError.RepositoryError.dataNotFound)
            return
        }
        
        let chattingViewModel = GPTChattingViewModel(chatRoomDTO: chatRoom, httpRequest: Network.GPTRequest.chatBot(apiKey: apiKey))
        let promptSettingViewModel = GPTPromptSettingViewModel(chatRoom: chatRoom)
        
        moveToChattingSubject.send(chattingViewModel)
        moveToPromptSettingSubject.send(promptSettingViewModel)
    }
}

extension GPTChatRoomsViewModel {
    private func handleRooms(_ handler: () throws -> Void) {
        do {
            try handler()
            updateChatRoomsSubject.send(chatRoomList.reversed())
        } catch {
            errorSubject.send(error)
        }
    }
    
    private func fetchChatRooms() {
        do {
            chatRoomList = try chatRoomRepository.fetchChatRoomList()
            updateChatRoomsSubject.send(chatRoomList.reversed())
        } catch {
            errorSubject.send(error)
        }
    }
}
