//
//  CoreDataPromptSettingRepository.swift
//  ChatBot
//
//  Created by 김준성 on 1/24/24.
//

import CoreData
import Foundation

extension Repository {
    final class CoreDataPromptSettingRepository {
        let coreDataRepository: Repository.CoreDataRepository
        
        init(coreDataRepository: Repository.CoreDataRepository = AppEnviroment.defaultCDRepository) {
            self.coreDataRepository = coreDataRepository
        }
        
        private func fetchChatRoom(_ chatRoom: Model.GPTChatRoomDTO) throws -> ChatRoom {
            let request = ChatRoom.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", chatRoom.id.uuidString)
            
            guard let chatRoomCD = try coreDataRepository.context.fetch(request).first else {
                throw GPTError.RepositoryError.dataNotFound
            }
            
            return chatRoomCD
        }
    }
}

extension Repository.CoreDataPromptSettingRepository: PromptSettingRepositable {
    func fetchPromptSetting(for chatRoom: Model.GPTChatRoomDTO) throws -> Model.SystemMessage? {
        let chatRoomCD = try fetchChatRoom(chatRoom)
        
        guard let prompt = chatRoomCD.promptSetting else {
            return nil
        }
        
        return Model.SystemMessage(content: prompt.content, name: nil)
    }
    
    func modifyPromptSetting(_ systemMessage: Model.SystemMessage, for chatRoom: Model.GPTChatRoomDTO) throws {
        let chatRoomCD = try fetchChatRoom(chatRoom)
        
        guard let prompt = chatRoomCD.promptSetting else {
            throw GPTError.RepositoryError.dataNotFound
        }
        
        prompt.content = systemMessage.content
        
        try coreDataRepository.saveContext()
    }
    
    func deletePromptSetting(for chatRoom: Model.GPTChatRoomDTO) throws {
        let chatRoomCD = try fetchChatRoom(chatRoom)
        
        guard let promptSetting = chatRoomCD.promptSetting else {
            return
        }
        
        coreDataRepository.context.delete(promptSetting)
        
        try coreDataRepository.saveContext()
    }
    
    func storePromptSetting(_ systemMessage: Model.SystemMessage, for chatRoom: Model.GPTChatRoomDTO) throws {
        let chatRoomCD = try fetchChatRoom(chatRoom)
        
        guard let promptSetting = NSManagedObject(entity: PromptSetting.entity(), insertInto: coreDataRepository.context) as? PromptSetting else {
            throw GPTError.RepositoryError.contextNotFound
        }
        promptSetting.id = UUID()
        promptSetting.role = systemMessage.role.rawValue
        promptSetting.content = systemMessage.content
        promptSetting.chatRoom = chatRoomCD
        
        chatRoomCD.promptSetting = promptSetting
        
        try coreDataRepository.saveContext()
    }
}
