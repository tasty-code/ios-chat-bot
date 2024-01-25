//
//  ChatRoomDataHandler.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/25/24.
//

import Foundation

final class ChatRoomDataHandler {
    private let dataManager: DataManagable
    
    init(dataManager: DataManagable = CoreDataManager.shared) {
        self.dataManager = dataManager
    }
    
    func fetchChatRoomData() -> [ChatRoom] {
        let request = RoomEntity.fetchRequest()
        guard let entities = try? dataManager.context.fetch(request)
        else {
            return []
        }
        return entities.compactMap {
            guard let uuid = $0.uuid,
                  let title = $0.title,
                  let date = $0.date
            else {
                return nil
            }
            return ChatRoom(uuid: uuid, title: title, date: date)
        }
    }
}
