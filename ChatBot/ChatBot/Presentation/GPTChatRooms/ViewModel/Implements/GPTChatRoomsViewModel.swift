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
        bindFetchRoom(from: input.fetchRooms)
        bindCreateRoom(from: input.createRoom)
        bindDeleteRoom(from: input.deleteRoom)
        bindSelectRoom(from: input.selectRoom)
        bindModifyRoom(from: input.modifyRoom)
        
        return output.eraseToAnyPublisher()
    }
}

extension GPTChatRoomsViewModel {
    private func bindFetchRoom(from publisher: AnyPublisher<Void, Never>?) {
        publisher?
            .sink { [weak self] _ in
                guard let chatRoomList = try? self?.chatRoomRepository.fetchChatRoomList() else {
                    self?.output.send(Output.failure(error: GPTError.RepositoryError.dataNotFound))
                    return
                }
                self?.chatRoomList = chatRoomList
                self?.output.send(Output.success(rooms: chatRoomList))
            }
            .store(in: &cancellables)
    }
    
    private func bindCreateRoom(from publisher: AnyPublisher<String?, Never>?) {
        publisher?
            .sink { [weak self] title in
                guard let self else { return }
                guard let title = title, title.count > 0 else {
                    output.send(Output.failure(error: GPTError.ChatRoomError.noRoomName))
                    return
                }
                
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
    }
    
    private func bindDeleteRoom(from publisher: AnyPublisher<IndexPath, Never>?) {
        publisher?
            .sink { [weak self] indexPath in
                guard let self else { return }
                do {
                    let chatRoom = chatRoomList[indexPath.item]
                    try chatRoomRepository.removeChatRoom(chatRoom)
                    chatRoomList.remove(at: indexPath.item)
                    output.send(Output.success(rooms: chatRoomList))
                } catch {
                    output.send(Output.failure(error: error))
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindSelectRoom(from publisher: AnyPublisher<IndexPath, Never>?) {
        publisher?
            .sink { [weak self] indexPath in
                guard let self else { return }
                guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "CHAT_BOT_API_KEY") as? String else {
                    output.send(Output.failure(error: GPTError.RepositoryError.dataNotFound))
                    return
                }
                
                output.send(Output.moveToChatRoom(
                    chatRoomViewModel: GPTChattingViewModel(chatRoomDTO: chatRoomList[indexPath.item],
                        httpRequest: Network.GPTRequest.chatBot(apiKey: apiKey))
                ))
            }
            .store(in: &cancellables)
    }
    
    private func bindModifyRoom(from publisher: AnyPublisher<(IndexPath, String?), Never>?) {
        publisher?
            .sink { [weak self] (indexPath, title) in
                guard let self else { return }
                guard let title = title, title.count > 0 else {
                    output.send(Output.failure(error: GPTError.ChatRoomError.noRoomName))
                    return
                }
                
                let chatRoomDTO = Model.GPTChatRoomDTO(id: chatRoomList[indexPath.item].id, title: title, recentChatDate: chatRoomList[indexPath.item].recentChatDate)
                do {
                    try chatRoomRepository.modifyChatRoom(chatRoomDTO)
                    chatRoomList[indexPath.item] = chatRoomDTO
                    output.send(Output.success(rooms: chatRoomList))
                } catch {
                    output.send(Output.failure(error: error))
                }
            }
            .store(in: &cancellables)
    }
}
