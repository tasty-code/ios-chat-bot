//
//  ChatServiceDelegate.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/15.
//

import Foundation

protocol ChatServiceDelegate: AnyObject {
    func injectChatServiceDelegate() -> ChatService
}
