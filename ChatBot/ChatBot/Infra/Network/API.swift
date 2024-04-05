
import Foundation

enum API {
    case chat(messages: [Message])
}

extension API {
    func toURLRequest() -> URLRequest? {
        let header = [
            API.contentTypeKey: API.contentType,
            API.AuthorizationKey: Bundle.main.chatBotAPIKey
        ]
        
        switch self {
        case .chat(let messages):
            let body = ChatBotRequestDTO(model: API.chatBotModel, 
                                         stream: false,
                                         messages: messages.map { MessageDTO(from: $0) })
            
            return URLRequestBuilder(baseURL: API.baseURL)
                .setPath(API.path)
                .setMethod(.post)
                .setHeaderParameters(header)
                .setBodyParameters(body)
                .build()
        }
    }
}

extension API {
    private static let baseURL = "api.openai.com"
    private static let chatBotModel = "gpt-3.5-turbo-1106"
    private static let path = "/v1/chat/completions"
    private static let contentTypeKey = "Content-Type"
    private static let contentType = "application/json"
    private static let AuthorizationKey = "Authorization"
}
