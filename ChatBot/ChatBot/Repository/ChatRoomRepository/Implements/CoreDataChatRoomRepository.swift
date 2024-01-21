//
//  CoreDataChatRoomRepository.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import Foundation
import CoreData

extension Repository {
    final class CoreDataChatRoomRepository {
        let coreDataRepository: Repository.CoreDataRepository
        
        init(coreDataRepository: Repository.CoreDataRepository = AppEnviroment.defaultCDRepository) {
            self.coreDataRepository = coreDataRepository
        }
    }
}

extension Repository.CoreDataChatRoomRepository: ChatRoomRepositable {
    func fetchChatRoom() throws {
        
    }
    
    func fetchChatRoomList() throws -> [Model.GPTChatRoomDTO] {
        let request = ChatRoom.fetchRequest()
        let chatRoomList = try coreDataRepository.context.fetch(request)
        
        return chatRoomList.map { chatRoom in
            return Model.GPTChatRoomDTO(id: chatRoom.id!, title: chatRoom.title!, recentChatDate: chatRoom.recentChatDate!)
        }
    }
    
    func storeChatRoom(_ chatRoom: Model.GPTChatRoomDTO) throws {
        guard let chatRoomCD = NSManagedObject(entity: ChatRoom.entity(), insertInto: coreDataRepository.context) as? ChatRoom else {
            throw GPTError.RepositoryError.contextNotFound
        }
        
        chatRoomCD.id = chatRoom.id
        chatRoomCD.title = chatRoom.title
        chatRoomCD.recentChatDate = chatRoom.recentChatDate
        
        try coreDataRepository.saveContext()
    }
    
    func modifyChatRoom(_ chatRoom: Model.GPTChatRoomDTO) throws {
        let request = ChatRoom.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", chatRoom.id.uuidString)
        request.predicate = predicate
        
        guard let result = try? coreDataRepository.context.fetch(request).first else {
            throw GPTError.RepositoryError.dataNotFound
        }
        
        result.title = chatRoom.title
        try coreDataRepository.saveContext()
    }
    
    func removeChatRoom(_ chatRoom: Model.GPTChatRoomDTO) throws {
        let request = ChatRoom.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", chatRoom.id.uuidString)
        request.predicate = predicate
        
        guard let result = try? coreDataRepository.context.fetch(request).first else {
            throw GPTError.RepositoryError.dataNotFound
        }
        
        coreDataRepository.context.delete(result)
        try coreDataRepository.saveContext()
    }
}
