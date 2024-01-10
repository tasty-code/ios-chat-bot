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
                (200...299) ~= response.statusCode 
        else
        {
            if let response = response as? HTTPURLResponse {
                throw NetworkError.httpError(response.statusCode)
            } else {
                throw NetworkError.failedTransformHTTPURLResponse
            }
        }
        
        guard let decodeData = try? JSONDecoder().decode(ChatResponseModel.self, from: data) else {
            throw DecoderError.failedDeocde
        }
        
        return decodeData
    }
}
