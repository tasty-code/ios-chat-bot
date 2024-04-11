//
//  ChatService.swift
//  ChatBot
//
//  Created by nayeon  on 4/3/24.
//

protocol ChatServiceProtocol {
    func sendChatRequest(message: String, completion: @escaping (NetworkResult<ResponseDTO>) -> Void)
}

final class ChatService: ChatServiceProtocol {
    
    func sendChatRequest(message: String, completion: @escaping (NetworkResult<ResponseDTO>) -> Void) {
        let requestDTO = RequestDTO(model: .basic, stream: false, messages: [MessageDTO(role: .user, content: message)])
        let router = APIRouter.chatCompletion(requestDTO: requestDTO)
        
        APIClient.request(ResponseDTO.self, router: router) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
