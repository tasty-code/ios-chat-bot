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
