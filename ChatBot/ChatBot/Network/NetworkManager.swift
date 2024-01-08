//
//  NetworkManager.swift
//  ChatBot
//
//  Created by 김예준 on 1/5/24.
//

import Foundation

final class NetworkManager {
    
    func loadData(request: URLRequest) async throws -> ChatResponseModel {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            let response = response as? HTTPURLResponse
            let statusCode = response?.statusCode ?? -1
            throw NetworkError.httpError(statusCode)
        }
        
        guard let decodeData = try? JSONDecoder().decode(ChatResponseModel.self, from: data) else {
            throw DecoderError.failedDeocde
        }
        
        return decodeData
    }
}
