//
//  ChatServiceProtocol.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/05.
//

import Foundation

protocol ChatServiceProtocol {
    func sendChats(chats: [ChatBubble], completion: @escaping (Result<ResponseData, Error>) -> Void) throws
}
// 내 짝꿍은 랄라야
//내 짝꿍이 누구라고?
