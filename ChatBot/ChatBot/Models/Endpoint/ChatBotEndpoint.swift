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

final class EndPointMaker {
    private var userContentStorage = [Message]()

    func buildEndpoint(_ userMessage: String) -> Endpointable? {
        guard let apiKey = Bundle.getAPIKey(for: APIKeyName.openAI.description) else {
            return nil
        }
        
        guard let url = URL(string: BaseURL.openAI.description) else {
            return nil
        }
        
        let newMessage = Message(role: UserContentConstant.userRole, content: userMessage)
        
        userContentStorage.append(newMessage)

        let body = UserContentModel(messages: userContentStorage)
        let header: [String: String] = [HeaderFieldName.contentType.description : ContentType.json.description,
                                        HeaderFieldName.authorization.description : "Bearer \(apiKey)"]
        let endpoint: Endpointable = ChatBotEndpoint(url: url, httpMethod: .post, httpHeader: header, httpBody: body)
        
        return endpoint
    }
}
