//
//  GPTChatRoomsViewModel.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import Combine
import Foundation

final class GPTChatRoomsViewModel: GPTChatRoomsOutputProtocol {
    typealias Output = GPTChatRoomsOutput
    
    var output: AnyPublisher<Output, Never> { outputSubject.eraseToAnyPublisher() }
    
    private let chatRoomRepository: ChatRoomRepositable
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private var chatRoomList = [Model.GPTChatRoomDTO]()
    
    init(chatRoomRepository: ChatRoomRepositable = Repository.CoreDataChatRoomRepository()) {
        self.chatRoomRepository = chatRoomRepository
    }
}

extension GPTChatRoomsViewModel: GPTChatRoomsInputProtocol {
    func onViewDidLoad() { }
    
    func onViewWillAppear() {
        outputSubject.send(fetchChatRooms())
    }
    
    func onViewDidDisappear() { }
    
    func createRoom(_ roomName: String?) {
        guard let roomName = roomName, !roomName.isEmpty else {
            outputSubject.send(Output.updateChatRooms(.failure(GPTError.ChatRoomError.noRoomName)))
            return
        }
        
        let chatRoom = Model.GPTChatRoomDTO(title: roomName, recentChatDate: Date())
        let output = handleRooms {
            try chatRoomRepository.storeChatRoom(chatRoom)
            chatRoomList.append(chatRoom)
        }
        outputSubject.send(output)
    }
    
    func modifyRoom(_ roomName: String?, for indexPath: IndexPath) {
        guard let roomName = roomName, !roomName.isEmpty else {
            outputSubject.send(Output.updateChatRooms(.failure(GPTError.ChatRoomError.noRoomName)))
            return
        }
        
        let previousChatRoom = chatRoomList[indexPath.item]
        let newChatRoom = Model.GPTChatRoomDTO(id: previousChatRoom.id, title: roomName, recentChatDate: previousChatRoom.recentChatDate)
        let output = handleRooms {
            try chatRoomRepository.modifyChatRoom(newChatRoom)
            chatRoomList[indexPath.item] = newChatRoom
        }
        outputSubject.send(output)
    }
    
    func deleteRoom(for indexPath: IndexPath) {
        let chatRoom = chatRoomList[indexPath.item]
        let output = handleRooms {
            try chatRoomRepository.removeChatRoom(chatRoom)
            chatRoomList.remove(at: indexPath.item)
        }
        outputSubject.send(output)
    }
    
    func selectRoom(for indexPath: IndexPath) {
        let chatRoom = chatRoomList[indexPath.item]
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "CHAT_BOT_API_KEY") as? String else {
            let output = Output.moveToChatRoom(.failure(GPTError.RepositoryError.dataNotFound))
            outputSubject.send(output)
            return
        }
        let viewModel = GPTChattingViewModel(chatRoomDTO: chatRoom, httpRequest: Network.GPTRequest.chatBot(apiKey: apiKey))
        outputSubject.send(Output.moveToChatRoom(.success(viewModel)))
    }
}

extension GPTChatRoomsViewModel {
    private func handleRooms(_ handler: () throws -> Void) -> Output {
        do {
            try handler()
            return Output.updateChatRooms(.success(chatRoomList.reversed()))
        } catch {
            return Output.updateChatRooms(.failure(error))
        }
    }
    
    private func fetchChatRooms() -> Output {
        let output = handleRooms {
            chatRoomList = try chatRoomRepository.fetchChatRoomList()
        }
        return output
    }
}
