//
//  OpenAIRepository.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/29.
//

import Foundation

protocol OpenAIRepository {
    associatedtype D: Decodable
    associatedtype E: Encodable
    
    func sendRequest(request: E) async -> D
}
