//
//  GPTPromptSettingViewModel.swift
//  ChatBot
//
//  Created by 김준성 on 1/24/24.
//

import Combine
import Foundation

final class GPTPromptSettingViewModel: GPTPromptSettingOutputProtocol {
    private let chatRoom: Model.GPTChatRoomDTO
    private let fetchPromptSettingSubject = PassthroughSubject<String?, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    private var systemMessage: Model.SystemMessage?
    
    var fetchPromptSetting: AnyPublisher<String?, Never> { fetchPromptSettingSubject.eraseToAnyPublisher() }
    var error: AnyPublisher<Error, Never> { errorSubject.eraseToAnyPublisher() }
    
    private let promptSettingRepository: PromptSettingRepositable
    
    init(chatRoom: Model.GPTChatRoomDTO, promptSettingRepository: PromptSettingRepositable = Repository.CoreDataPromptSettingRepository()) {
        self.chatRoom = chatRoom
        self.promptSettingRepository = promptSettingRepository
    }
    
    private func fetch() {
        do {
            systemMessage = try promptSettingRepository.fetchPromptSetting(for: chatRoom)
            fetchPromptSettingSubject.send(systemMessage?.content)
        } catch {
            errorSubject.send(error)
        }
    }
}

extension GPTPromptSettingViewModel: GPTPromptSettingInputProtocol {
    func onViewDidLoad() { }
    
    func onViewWillAppear() {
        fetch()
    }
    
    func storeUpdatePromptSetting(content: String?) {
        do {
            guard let content = content, !content.isEmpty else {
                try promptSettingRepository.deletePromptSetting(for: chatRoom)
                return
            }
            
            let newSystemMessage = Model.SystemMessage(content: content, name: nil)
            try promptSettingRepository.storePromptSetting(newSystemMessage, for: chatRoom)
        } catch {
            print(error)
        }
    }
}
