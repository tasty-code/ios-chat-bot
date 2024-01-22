//
//  ChatBotEndpoint.swift
//  ChatBot
//
//  Created by 김경록 on 1/10/24.
//

import Foundation

struct ChatBotEndpoint: Endpointable {
    var url: URL? = URL(string: BaseURL.openAI.description)
    var accessKey: String? = Bundle.getAPIKey(for: APIKeyName.openAI.description)
    var httpMethod: String = HTTPMethod.post.description
    var httpHeader: [String : String] = ["Content-Type": "application/json"]
    var httpBodyContent: UserContentModel = UserContentModel(messages: [])
    var useAuthorization: Bool = true
}
