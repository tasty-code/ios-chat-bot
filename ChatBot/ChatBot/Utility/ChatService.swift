//
//  ChatService.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/15.
//

import Foundation

struct ChatService {
    private let url: APIBaseURLProtocol
    private let networkManager: NetworkManager
    
    init(url: APIBaseURLProtocol, httpMethod: HttpMethod, contentType: ContentType) {
        self.url = url
        self.networkManager = NetworkManager(urlRequest: url.makeURLRequest(httpMethod: httpMethod, contentType: contentType))
    }
}

extension ChatService: OpenAIServiceProtocol {
    func sendRequestDTO<E: Encodable, D: Decodable>(inputData: E) async throws -> D {
        return try await networkManager.requestData(inputData:  inputData)
    }
}
