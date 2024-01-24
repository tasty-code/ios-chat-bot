//
//  PromptSettingRepositable.swift
//  ChatBot
//
//  Created by 김준성 on 1/24/24.
//

import Foundation

protocol PromptSettingRepositable {
    func fetchPromptSetting(for chatRoom: Model.GPTChatRoomDTO) throws -> Model.SystemMessage?
    func modifyPromptSetting(_ systemMessage: Model.SystemMessage, for chatRoom: Model.GPTChatRoomDTO) throws
    func deletePromptSetting(for chatRoom: Model.GPTChatRoomDTO) throws
    func storePromptSetting(_ systemMessage: Model.SystemMessage, for chatRoom: Model.GPTChatRoomDTO) throws
}
