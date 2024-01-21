//
//  CoreDataChattingRepository.swift
//  ChatBot
//
//  Created by 김준성 on 1/21/24.
//

import Foundation
import CoreData

extension Repository {
    final class CoreDataChattingRepository {
        let coreDataRepository: Repository.CoreDataRepository
        
        init(coreDataRepository: Repository.CoreDataRepository = AppEnviroment.defaultCDRepository) {
            self.coreDataRepository = coreDataRepository
        }
        
        private func fetchChatRoom(_ chatRoomDTO: Model.GPTChatRoomDTO) throws -> ChatRoom {
            let chatRoomRequest = ChatRoom.fetchRequest()
            chatRoomRequest.predicate = NSPredicate(format: "id == %@", chatRoomDTO.id.uuidString)
            
            guard let chatRoom = try? coreDataRepository.context.fetch(chatRoomRequest).first else {
                throw GPTError.RepositoryError.dataNotFound
            }
            
            return chatRoom
        }
    }
}

extension Repository.CoreDataChattingRepository: ChattingRepositable {
    func fetchChattings(for chatRoomDTO: Model.GPTChatRoomDTO) throws -> [Model.GPTMessage] {
        let chatRoom = try fetchChatRoom(chatRoomDTO)
        
        let chattingsRequest = Chatting.fetchRequest()
        chattingsRequest.predicate = NSPredicate(format: "chatRoom = %@", chatRoom)
        
        let chattings = try coreDataRepository.context.fetch(chattingsRequest)
        return chattings.map { Model.GPTMessage(role: Model.GPTMessageRole(rawValue: $0.role!)!, content: $0.content, name: nil, toolCalls: nil, toolCallID: nil) }
    }
    
    func storeChattings(_ chattings: [Model.GPTMessage], for chatRoomDTO: Model.GPTChatRoomDTO) throws {
        let chatRoom = try fetchChatRoom(chatRoomDTO)
        
        for chatting in chattings {
            guard let chattingCD = NSManagedObject(entity: Chatting.entity(), insertInto: coreDataRepository.context) as? Chatting else {
                continue
            }
            chattingCD.id = chatting.id
            chattingCD.role = chatting.role.rawValue
            chattingCD.content = chatting.content
            
            chatRoom.addToChattings(chattingCD)
        }
        
        try coreDataRepository.saveContext()
    }
}
