//
//  ContentEncoder.swift
//  ChatBot
//
//  Created by 김경록 on 1/8/24.
//

import Foundation

struct ContentEncoder {
    enum Constant {
        static let model = "gpt-3.5-turbo"
        static let stream = false
        static let AIRole = "assistant"
        static let AIContent = "You are a helpful assistant."
        static let UserRole = "user"
    }
    
    func transformData(_ content: String) -> Data? {
        let userMessages: [UserMessage] = [UserMessage(role: Constant.AIRole, content: Constant.AIContent),
                                           UserMessage(role: Constant.UserRole, content: content)]
        let userContent = UserContentModel(model: Constant.model, stream: Constant.stream, userMessage: userMessages)
        
        guard let encodedData = try? JSONEncoder().encode(userContent) else {
            print("유저 입력값 인코딩 에러")
            return nil
        }
        
        return encodedData
    }
}
