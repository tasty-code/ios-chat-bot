//
//  GPTPromptSettingViewModel.swift
//  ChatBot
//
//  Created by 김준성 on 1/24/24.
//

import Combine
import Foundation

final class GPTPromptSettingViewModel: GPTPromptSettingOutputProtocol {
    typealias Output = GPTPromptSettingOutput
    
    private let chatRoom: Model.GPTChatRoomDTO
    private var systemMessage: Model.SystemMessage?
    
    private let promptSettingRepository: PromptSettingRepositable
    private let outputSubject = PassthroughSubject<GPTPromptSettingOutput, Never>()
    
    var output: AnyPublisher<GPTPromptSettingOutput, Never> { outputSubject.eraseToAnyPublisher() }
    
    init(chatRoom: Model.GPTChatRoomDTO, promptSettingRepository: PromptSettingRepositable = Repository.CoreDataPromptSettingRepository()) {
        self.chatRoom = chatRoom
        self.promptSettingRepository = promptSettingRepository
    }
    
    private func fetchPromptSetting() throws {
        systemMessage = try promptSettingRepository.fetchPromptSetting(for: chatRoom)
        outputSubject.send(.fetch(.success(systemMessage?.content)))
    }
}

extension GPTPromptSettingViewModel: GPTPromptSettingInputProtocol {
    func onViewDidLoad() { }
    
    func onViewWillAppear() {
        do {
            try fetchPromptSetting()
        } catch {
            outputSubject.send(.fetch(.failure(error)))
        }
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
