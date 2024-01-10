//
//  ChatBotEndpoint.swift
//  ChatBot
//
//  Created by 김경록 on 1/10/24.
//

import Foundation

struct ChatBotEndpoint: Endpointable {
    var url: URL? = URL(string: BaseURL.openAI.description)
    var apiKey: String? = Bundle.getAPIKey(for: "openAI_APIKey")
    var httpMethod: HTTPMethods = HTTPMethods.post
    var contentType: ContentTypes? = ContentTypes.json
    var httpBody: Data?
}
