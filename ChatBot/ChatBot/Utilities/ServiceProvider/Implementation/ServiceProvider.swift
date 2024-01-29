//
//  GPTServiceProvider.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/09.
//

import Foundation

final class ServiceProvider: ServiceProvidable {
    private let networkManager: NetworkManager
    private let encoder: DataEncodable
    private let decoder: DataDecodable
    
    init(networkManager: NetworkManager,
         encoder: DataEncodable = JSONEncoder(), 
         decoder: DataDecodable = JSONDecoder()
    ) {
        self.networkManager = networkManager
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func excute<E: APIEndPoint, D: ResponseDTODecodable>(for endPoint: E) async throws -> D {
        let urlRequest = try endPoint.makeURLRequest(with: encoder)
        let data = try await networkManager.fetchData(with: urlRequest)
        let responseDTO = try decoder.decode(to: D.self, from: data)
        return responseDTO
    }
}
