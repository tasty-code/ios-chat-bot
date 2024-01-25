//
//  OpenAIServiceProtocol.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/25.
//

import Foundation

protocol OpenAIServiceProtocol {
    func sendRequestDTO<E: Encodable, D: Decodable>(inputData: E) async throws -> D
}
