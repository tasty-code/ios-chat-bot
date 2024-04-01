//
//  OpenAIService.swift
//  ChatBot
//
//  Created by 권태호 on 28/03/2024.
//

import Foundation

class OpenAIService {
    func sendRequestToOpenAI(_ messages: [RequestMessageModel], completion: @escaping (Result<[RequestMessageModel], Error>) -> Void) {
        let endpoint = OpenAIEndPoint.chatCompletionsBaseURL
        guard let url = endpoint.url else { return }
    
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(APIKeyManager.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages.map { ["role": $0.role.rawValue, "content": $0.content] }
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            
            do {
                let responseDTO = try JSONDecoder().decode(OpenAICheatResponseDTO.self, from: data)
                let messages = responseDTO.choices.compactMap { choice -> RequestMessageModel? in
                    guard let messageContent = choice.message?.content,
                          let messageRole = choice.message?.role,
                          let role = MessageRole(rawValue: messageRole) else { return nil }
                    return RequestMessageModel(role: role, content: messageContent)
                }
                completion(.success(messages))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
