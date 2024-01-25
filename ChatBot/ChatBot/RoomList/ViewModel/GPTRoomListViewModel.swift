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
        roomList = dataHandler.fetchChatRoomData().sorted { $0.date > $1.date }
    }
    
    func getChatRoom(at index: Int) -> ChatRoom {
        return roomList[index]
    }
}
