//
//  NetworkManager.swift
//  ChatBot
//
//  Created by 김예준 on 1/5/24.
//

import Foundation

final class NetworkManager {
    let defaultSession = URLSession(configuration: .default)

    func loadData(request: URLRequest) async throws -> ChatResponseModel {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            throw NetworkError.outOfRangeSuccessCode
        }
        
        guard let decodeData = try? JSONDecoder().decode(ChatResponseModel.self, from: data) else {
            throw DecoderError.failedDeocder
        }
        
        return decodeData
    }
}
