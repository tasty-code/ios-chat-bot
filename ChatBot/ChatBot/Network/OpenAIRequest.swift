import Foundation

struct OpenAIRequest: Requestable {
    static let apiKey: String = Bundle.main.apiKey
    
    static let defaultHeaders: [String: String] = {
        let authHeader = HTTPRequest.HeaderField.authorization(.bearer(token: Self.apiKey)).header
        let contentTypeHeader = HTTPRequest.HeaderField.contentType(.application(.json)).header
        
        return [
            authHeader.key: authHeader.value,
            contentTypeHeader.key: contentTypeHeader.value
        ]
    }()
    
    let baseURL: String
    let path: String
    let headerParameters: [String: String]
    let queryParameters: [String: Any]
    let method: HTTPMethodType
    let body: Data?
    
    init(
        baseURL: String = Constant.baseURL,
        path: String = Constant.chatPath,
        headerParameters: [String: String] = [:],
        queryParameters: [String: Any] = [:],
        method: HTTPMethodType = .post,
        body: Data?
    ) {
        self.baseURL = baseURL
        self.path = path
        self.headerParameters = headerParameters
        self.queryParameters = queryParameters
        self.method = method
        self.body = body
    }
    
    enum Constant {
        static let baseURL: String = "api.openai.com"
        static let chatPath: String = "/v1/chat/completions"
    }
}
