import Foundation

final class URLRequestBuilder {
    private let baseURL: String
    private let path: String
    private var headerParameters: [String: String] = [:]
    private var queryParameters: [String: String] = [:]
    private var method: HTTPMethod = .get
    private var bodyParameters: Encodable?
    private let encoder: JSONEncoder = JSONEncoder()
    
    init(baseURL: String,
         path: String
     ) {
        self.baseURL = baseURL
        self.path = path
    }
}

extension URLRequestBuilder {
    private func buildURL() -> URL? {
        var components = URLComponents()
        components.scheme = URLScheme.https.rawValue
        components.host = baseURL
        components.path = path
        components.queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1) }
        return components.url
    }
    
    func build() -> URLRequest? {
        guard let url = buildURL() else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        if let body = bodyParameters {
            urlRequest.httpBody = try? encoder.encode(body)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headerParameters
        return urlRequest
    }
    
    func setHeaderParameters(_ headerParameters: [String: String]) -> Self {
        self.headerParameters = headerParameters
        return self
    }
    
    func setQueryParameters(_ queryParameters: [String: String]) -> Self {
        self.queryParameters = queryParameters
        return self
    }
    
    func setMethod(_ method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    func setBodyParameters(_ bodyParameters: Encodable) -> Self {
        self.bodyParameters = bodyParameters
        return self
    }
    
}

