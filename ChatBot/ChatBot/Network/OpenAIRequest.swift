import Foundation

struct OpenAIRequest: Requestable {
    let baseURL: String
    let path: String
    let headerParameters: [String: String]
    let queryParameters: [String: Any]
    let method: HTTPMethodType
    let body: Data?
    
    init(
        baseURL: String,
        path: String,
        headerParameters: [String: String] = [:],
        queryParameters: [String: Any] = [:],
        method: HTTPMethodType = .post,
        body: Data? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.headerParameters = headerParameters
        self.queryParameters = queryParameters
        self.method = method
        self.body = body
    }
}
