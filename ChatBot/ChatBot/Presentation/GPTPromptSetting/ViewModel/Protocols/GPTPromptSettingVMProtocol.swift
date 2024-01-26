//
//  GPTPromptSettingVMProtocol.swift
//  ChatBot
//
//  Created by 김준성 on 1/26/24.
//

import Combine
import Foundation

typealias GPTPromptSettingVMProtocol = GPTPromptSettingInput & GPTPromptSettingOutput

protocol GPTPromptSettingInput {
    func onViewDidLoad()
    func onViewWillAppear()
    func storeUpdatePromptSetting(content: String?)
}

protocol GPTPromptSettingOutput {
    var fetchPromptSetting: AnyPublisher<String?, Never> { get }
    var error: AnyPublisher<Error, Never> { get }
}
