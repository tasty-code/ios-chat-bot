//
//  OpenAIService.swift
//  ChatBot
//
//  Created by 권태호 on 28/03/2024.
//

import Foundation

class OpenAIService {
    func sendRequestToOpenAI(_ messages: [RequestMessageModel],
                             model: GPTModel,
                             APIkey: String,
                             completion: @escaping (Result<[RequestMessageModel],Error>) -> Void) {
        
        let reqeustBuilder = URLRequestBuilder()
        guard let url = OpenAIEndPoint.chatCompletionsBaseURL.url else {
            completion(.failure(NetworkError.urlError))
            return
        }
        
        do {
            let request = try reqeustBuilder.makeRequest(url: url, for: model, APIKey: APIkey, withMessages: messages)
            performReqeust(request, completion: completion)
        } catch {
            completion(.failure(NetworkError.connectionError))
        }
    }
    
    private func performReqeust(_ request: URLRequest, completion: @escaping (Result<[RequestMessageModel], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
             if let error = error {
                 completion(.failure(error))
                 return
             }
            
             guard let data = data else {
                 completion(.failure(NetworkError.dataNotFound))
                 return
             }
            
            if let httpResponse = response as? HTTPURLResponse {
                     print("HTTP Status Code: \(httpResponse.statusCode)")
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
                 completion(.failure(NetworkError.connectionError))
             }
         }
         task.resume()
     }
}
