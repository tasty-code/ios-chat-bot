//
//  ChatBotEndpoint.swift
//  ChatBot
//
//  Created by 김경록 on 1/10/24.
//

import Foundation

struct ChatBotEndpoint: Endpointable {
    var url: URL
    var apiKey: String?
    var httpMethod: HTTPMethod
    var httpHeader: [String : String]?
    var httpBody: Encodable
}
