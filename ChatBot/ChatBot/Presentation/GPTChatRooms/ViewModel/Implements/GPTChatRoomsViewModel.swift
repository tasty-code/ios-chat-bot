//
//  GPTChatRoomsViewModel.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import Combine
import Foundation

final class GPTChatRoomsViewModel: GPTChatRoomsVMProtocol {
    private let chatRoomRepository: ChatRoomRepositable
    private let output = PassthroughSubject<Output, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private var chatRoomList = [Model.GPTChatRoomDTO]()
    
    init(chatRoomRepository: ChatRoomRepositable = Repository.CoreDataChatRoomRepository()) {
        self.chatRoomRepository = chatRoomRepository
    }
    
    func transform(from input: GPTChatRoomsInput) -> AnyPublisher<GPTChatRoomsOutput, Never> {
        input.fetchRooms
            .sink { [weak self] _ in
                guard let chatRoomList = try? self?.chatRoomRepository.fetchChatRoomList() else {
                    self?.output.send(Output.failure(error: GPTError.RepositoryError.dataNotFound))
                    return
                }
                self?.chatRoomList = chatRoomList
                self?.output.send(Output.success(rooms: chatRoomList))
            }
            .store(in: &cancellables)
        
        input.createRoom
            .sink { [weak self] title in
                guard let self else { return }
                let chatRoomDTO = Model.GPTChatRoomDTO(title: title, recentChatDate: Date())
                do {
                    try chatRoomRepository.storeChatRoom(chatRoomDTO)
                    chatRoomList.append(chatRoomDTO)
                    output.send(Output.success(rooms: chatRoomList))
                } catch {
                    output.send(Output.failure(error: error))
                }
            }
            .store(in: &cancellables)
        
        input.deleteRoom
            .sink { [weak self] (chatRoom, indexPath) in
                guard let self else { return }
                do {
                    try chatRoomRepository.removeChatRoom(chatRoom)
                    chatRoomList.remove(at: indexPath.item)
                    output.send(Output.success(rooms: chatRoomList))
                } catch {
                    output.send(Output.failure(error: error))
                }
            }
            .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}
