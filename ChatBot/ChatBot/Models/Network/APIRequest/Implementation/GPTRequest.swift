//
//  GPTRequest.swift
//  ChatBot
//
//  Created by 김진웅 on 1/5/24.
//

import Foundation

struct GPTRequest: APIRequestable {
    let baseURL: String = "https://api.openai.com/v1/chat/completions"
    let headerFields: [String : String]
    let bodyDTO: Encodable?
    
    init(requestDTO: Encodable) throws {
        guard let apiKey = Bundle.main.gptAPIKey
        else {
            throw NetworkError.notFoundAPIKey
        }
        
        headerFields = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type" : "application/json"
        ]
        
        self.bodyDTO = requestDTO
    }
}
