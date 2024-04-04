//
//  OpenAIEndPoint.swift
//  ChatBot
//
//  Created by 권태호 on 28/03/2024.
//

import Foundation

struct OpenAIEndPoint {
    let path: String
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openai.com"
        components.path = "/" + path
        return components.url
    }
}

extension OpenAIEndPoint {
    static let chatCompletionsBaseURL = OpenAIEndPoint(path: "v1/chat/completions")
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}



