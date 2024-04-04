import Foundation

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var headerParameters: [String: String] { get }
    var queryParameters: [String: Any] { get }
    var method: HTTPMethodType { get }
    var body: Data? { get }
    
    func toURLRequest() -> URLRequest?
}

extension Requestable {
    private func toURL() -> URL? {
        var components = URLComponents()
        components.scheme = URLScheme.https.rawValue
        components.host = self.baseURL
        components.path = self.path
        components.queryItems = self.queryParameters.map { URLQueryItem(name: $0, value: $1 as? String) }
        return components.url
    }
    
    func toURLRequest() -> URLRequest? {
        guard let url = toURL() else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.allHTTPHeaderFields = self.headerParameters
        
        urlRequest.httpBody = self.body
        return urlRequest
    }
}

