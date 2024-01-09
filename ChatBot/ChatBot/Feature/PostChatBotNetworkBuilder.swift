//
//  PostChatBotNetworkBuilder.swift
//  ChatBot
//
//  Created by Janine on 1/5/24.
//

import Foundation

struct PostChatBotNetworkBuilder: NetworkRequestBuildable {
    typealias RequestBody = APIRequest
    
    var httpMethod: HttpMethod = .post
    let authKey: String? = Environment.apiKey
    var body: RequestBody
    
    var path: String
    
    init(prompt: String) {
        self.path = "v1/chat/\(Endpoint.completions.rawValue)"
        self.body = APIRequest(
            model: ConstantsForNetworkRequest.model,
            stream: false,
            messages: [
                ConstantsForNetworkRequest.defaultMessage,
                Message(role: "user", content: prompt)
            ]
        )
    }
}
