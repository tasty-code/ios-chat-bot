//
//  NetworkManager.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/05.
//

import Foundation

struct NetworkManager {
    private let session: URLSession
    private var request: URLRequest?

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

// MARK: - protocol method
extension NetworkManager: NetworkManagerProtocol {
    func getData (handler: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let request = request else { return }

        session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                return handler(.failure(.unknown))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return }
            guard (200..<300) ~= httpResponse.statusCode else {
                print(httpResponse.statusCode)
                return handler(.failure(.invalidResponse))
            }
            
            guard let data = data else {
                return handler(.failure(.invalidData))
            }
            
            handler(.success(data))
        }.resume()
    }
}
