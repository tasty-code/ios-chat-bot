//
//  RequestGenerator.swift
//  ChatBot
//
//  Created by 전성수 on 1/8/24.
//

import Foundation

struct RequestGenerator {
    private let urlString = "https://api.openai.com/v1/chat/completions"
    
    func generateRequest(_ httpBody: Data) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        guard let APIKey = Bundle.getAPIKey(for: "openAI_APIKey") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(APIKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = httpBody
        
        return request
    }
}
