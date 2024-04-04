import Foundation

enum URLScheme: String {
    case http
    case https
}

enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var headerParameters: [String: String] { get }
    var queryParameters: [String: Any] { get }
    var method: HTTPMethodType { get }
    var bodyParameters: Encodable? { get }
    
    func toURLRequest() -> URLRequest?
}

extension Requestable {
    private func toURL() -> URL? {
        var components = URLComponents()
        components.scheme = URLScheme.https.rawValue
        components.host = baseURL
        components.path = path
        components.queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1 as? String) }
        return components.url
    }
    
    func toURLRequest() -> URLRequest? {
        guard let url = toURL() else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headerParameters
        
        if let bodyParameters = bodyParameters {
            urlRequest.httpBody = try? JSONEncoder().encode(bodyParameters)
        }
        return urlRequest
    }
}

