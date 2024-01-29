//
//  ChatTextInputViewButtonDelegate.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/26.
//

import Foundation

protocol ChatTextInputViewButtonDelegate: AnyObject {
    func sendMessage(_ message: String)
}
