//
//  ChatSendMessageBuilder.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/05.
//

import Foundation

struct ChatSendMessageBuilder: NetworkBuilderProtocol {
    let method: HttpMethod = .POST
    let path = "v1/chat/completions"
    var header: [String : String] {
        ["Content-Type" : "application/json",
         "Authorization": "Bearer \(Bundle.main.apiKey ?? "")"]
    }
    var body: Data
}

enum HttpMethod: String {
    case POST
    case GET
    case PUT
    case DELETE
}
