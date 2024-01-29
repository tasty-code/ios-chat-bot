//
//  GPTRoomListViewModel.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/25/24.
//

import Foundation

final class GPTRoomListViewModel {
    var didRoomAppend: (([ChatRoom]) -> Void)?
    
    private let dataHandler: ChatRoomDataHandler
    
    private var roomList: [ChatRoom] = [] {
        didSet {
            didRoomAppend?(roomList)
        }
    }
        
    init(dataHandler: ChatRoomDataHandler) {
        self.dataHandler = dataHandler
    }
    
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
