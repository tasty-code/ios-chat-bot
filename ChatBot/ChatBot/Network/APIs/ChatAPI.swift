//
//  ChatAPI.swift
//  ChatBot
//
//  Created by EUNJU on 4/1/24.
//

import Alamofire

enum ChatAPI {
    case createChat(systemContent: String, userContent: String)
}

extension ChatAPI: BaseAPI {
    
    var urlPath: String {
        switch self {
        case .createChat(_, _):
            return "/v1/chat/completions"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createChat:
            return .post
        }
    }
    
    var parameters: RequestParameter {
        switch self {
        case .createChat(let systemContent, let userContent):
            let body = ChatRequestModel(model: GPTModelFamilies.main.rawValue,
                                         messages: [
                                            Message(role: .system,
                                                    content: systemContent),
                                            Message(role: .user,
                                                    content: userContent)
                                         ])
            return .requestBody(body)
        }
    }
}
