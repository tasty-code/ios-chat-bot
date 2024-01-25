//
//  GPTRoomListViewModel.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/25/24.
//

import Foundation

final class GPTRoomListViewModel {
    private let dataHandler: ChatRoomDataHandler
    
    init(dataHandler: ChatRoomDataHandler) {
        self.dataHandler = dataHandler
    }
    
    private var roomList: [ChatRoom] = [] {
        didSet {
            didRoomAppend?(roomList)
        }
    }
    
    var didRoomAppend: (([ChatRoom]) -> Void)?
    
    
    func fetchRoomList() {
        roomList = dataHandler.fetchChatRoomData()
    }
    
    func getChatRoom(at index: Int) -> ChatRoom {
        return roomList[index]
    }
    
    func deleteChatRoom(at index: Int) {
        let chatRoom = roomList[index]
        dataHandler.deleteChatRoomData(with: chatRoom)
        roomList.remove(at: index)
    }
}
