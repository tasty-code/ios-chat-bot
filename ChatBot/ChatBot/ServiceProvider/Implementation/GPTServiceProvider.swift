//
//  GPTServiceProvider.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/09.
//

import Foundation

final class GPTServiceProvider: ServiceProvidable {
    typealias E = GPTRequestDTO
    typealias D = GPTResponseDTO
    
    private let networkManager: NetworkManager
    private let jsonCoder: JSONCodable
    
    init(networkManager: NetworkManager, jsonCoder: JSONCodable) {
        self.networkManager = networkManager
        self.jsonCoder = jsonCoder
    }
    
    func excute(for requestDTO: GPTRequestDTO) async throws -> GPTResponseDTO {
        let gptRequest = try GPTRequest(requestDTO: requestDTO)
        let urlRequest = try URLRequestConverter(apiRequest: gptRequest).asURLRequest(with: jsonCoder)
        let data = try await networkManager.fetchData(with: urlRequest)
        
        guard let responseDTO = try? jsonCoder.decode(GPTResponseDTO.self, from: data)
        else {
            throw NetworkError.failedDecoding
        }
        return responseDTO
    }
}
