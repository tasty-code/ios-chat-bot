//
//  NetworkManager.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/5/24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init () {}
    
    func fetch() {
        guard let url = URL(string: BaseURL.openAi), let apiKey = Bundle.main.apiKey else { return }
        
        let requestData = RequestData(messages: [Message(role: "user", content: "HI")])
        guard let encodedData = try? JSONEncoder().encode(requestData) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = encodedData
    
        let urlSession = URLSession.shared
        urlSession.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                let decodedData = try JSONDecoder().decode(ResponseData.self, from: data)
    
            } catch {
                
                return
            }
        }
        .resume()
    }
    
    
}
