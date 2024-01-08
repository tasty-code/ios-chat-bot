//
//  NetworkManager.swift
//  ChatBot
//
//  Created by 김예준 on 1/5/24.
//

import Foundation

final class NetworkManager {
    let defaultSession = URLSession(configuration: .default)
    
    func loadData(request: URLRequest) async throws -> Data {
        let (data, response) = try await defaultSession.data(for: request)
        guard let response = response as? HTTPURLResponse,
              (200...299) ~= response.statusCode
        else {
            throw NetworkError.outOfRangeSuccessCode
        }
        return data
    }
}
