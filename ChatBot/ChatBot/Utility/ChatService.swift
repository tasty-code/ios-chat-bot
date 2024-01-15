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

extension ChatService {
    func getRequestData<E: Encodable, D: Decodable>(inputData: E) async throws -> D {
        
        let encodedData = JSONConverter.encode(data: inputData)
        let responseData = try await networkManager.getData(body: encodedData)
        guard let decodedData = JSONConverter.decode(type: D.self, data: responseData) else {
            throw JSONConvertError.wrongDecoding
        }
        
        return decodedData
    }
}
