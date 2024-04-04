struct OpenAIRequest: Requestable {
    let baseURL: String
    let path: String
    let headerParameters: [String: String]
    let queryParameters: [String: Any]
    let method: HTTPMethodType
    let bodyParameters: Encodable?
    
    init(
        baseURL: String,
        path: String,
        headerParameters: [String: String] = [:],
        queryParameters: [String: Any] = [:],
        method: HTTPMethodType = .post,
        bodyParameters: Encodable? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.headerParameters = headerParameters
        self.queryParameters = queryParameters
        self.method = method
        self.bodyParameters = bodyParameters
    }
}
