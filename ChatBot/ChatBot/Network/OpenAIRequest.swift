import Foundation

struct OpenAIRequest: HTTPRequestable {
    enum Constant {
        static let openAIAPIKey: String = "OPENAI_API_KEY"
        static let baseURL: String = "api.openai.com"
        static let chatPath: String = "/v1/chat/completions"
    }
    
    private static let apiKey: String = {
        return APIKeyLoader.getAPIKey(by: Constant.openAIAPIKey)
    }()
    
    private static func makeHeaderParameters() -> [String: String] {
        let authHeader = HTTPRequest.HeaderField.authorization(.bearer(token: Self.apiKey)).header
        let contentTypeHeader = HTTPRequest.HeaderField.contentType(.application(.json)).header
        
        return [
            authHeader.key: authHeader.value,
            contentTypeHeader.key: contentTypeHeader.value
        ]
    }
    
    let baseURL: String
    let path: String
    let headerParameters: [String: String]
    let queryParameters: [String: Any]
    let method: HTTPMethodType
    let body: Data?
    
    init(
        method: HTTPMethodType = .post,
        body: Data?
    ) {
        self.baseURL = Constant.baseURL
        self.path = Constant.chatPath
        self.headerParameters = Self.makeHeaderParameters()
        self.queryParameters = [:]
        self.method = method
        self.body = body
    }
}
