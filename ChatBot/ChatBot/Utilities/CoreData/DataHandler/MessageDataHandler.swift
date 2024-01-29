//
//  MessageDataHandler.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/25/24.
//

import CoreData

final class MessageDataHandler {
    private let dataManager: DataManagable
    
    init(dataManager: DataManagable = CoreDataManager.shared) {
        self.dataManager = dataManager
    }
    
    private func fetchRoomEntity(with currentRoom: ChatRoom) throws -> RoomEntity {
        let request = RoomEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uuid == %@", currentRoom.uuid.uuidString)
        
        let entities = try dataManager.context.fetch(request)
        guard let entity = entities.first
        else {
            let newEntity = RoomEntity(context: dataManager.context)
            newEntity.uuid = currentRoom.uuid
            newEntity.date = currentRoom.date
            newEntity.title = currentRoom.title
            return  newEntity
        }
        return entity
    }
    
    func saveChat(at currentRoom: ChatRoom, with messages: [ChatMessage]) throws {
        let roomEntity = try fetchRoomEntity(with: currentRoom)
        
        guard let previousCount = roomEntity.messageRelationship?.count,
              previousCount < messages.count
        else {
            return
        }
        
        for i in previousCount..<messages.count {
            let message = messages[i]
            let entity = MessageEntity(context: dataManager.context)
            entity.uuid = message.uuid
            entity.content = message.content
            entity.role = "\(message.role)"
            entity.date = message.date
            
            roomEntity.addToMessageRelationship(entity)
        }
        roomEntity.date = messages.last?.date
        try dataManager.saveContext()
    }
    
    func fetchChats(at currentRoom: ChatRoom) -> [ChatMessage]  {
        do {
            let roomEntity = try fetchRoomEntity(with: currentRoom)
            
            let request = MessageEntity.fetchRequest()
            request.predicate = NSPredicate(format: "roomRelationship == %@", roomEntity)
            
            let entities = try dataManager.context.fetch(request)
            
            let messages: [ChatMessage] = entities.compactMap {
                guard let uuid = $0.uuid,
                      let content = $0.content,
                      let date = $0.date,
                      let roleString = $0.role,
                      let role = MessageRole(rawValue: roleString)
                else {
                    return nil
                }
                
                return ChatMessage(uuid: uuid, date: date, content: content, role: role)
            }
            return messages.sorted { $0.date < $1.date }
            
        } catch {
            return []
        }
    }
}
