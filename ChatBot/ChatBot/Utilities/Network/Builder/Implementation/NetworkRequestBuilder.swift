import Foundation

final class NetworkRequestBuilder {
    // MARK: Namespace
    enum NetworkBuilderError: Error {
        case buildRequestFailed
    }
    
    // MARK: Dependencies
    private let jsonEncodeManager: JSONEncodable
    
    // MARK: Private Properties
    private var url: URL?
    private var httpMethod: HTTPMethodType = .get
    private var httpHeaderFields: [String : String] = [:]
    private var requestModel: Encodable? = nil
    
    // MARK: Life Cycle
    init(jsonEncodeManager: JSONEncodable, endpoint: EndpointType) {
        self.jsonEncodeManager = jsonEncodeManager
        self.url = URL(string: (endpoint.baseURLString))
    }
    
    // MARK: Public Methods
    func setHttpMethod(httpMethod: HTTPMethodType) {
        self.httpMethod = httpMethod
    }
    
    func setHttpHeaderFields(httpHeaderFields: [String: String]) {
        self.httpHeaderFields = httpHeaderFields
    }
    
    func setRequestModel(requestModel: RequestModel) {
        self.requestModel = requestModel
    }
    
    func build() throws -> URLRequest {
        guard let url = url,
              let requestModel = requestModel
        else {
            throw NetworkBuilderError.buildRequestFailed
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.description
        request.allHTTPHeaderFields = httpHeaderFields
        request.httpBody = try jsonEncodeManager.encode(requestModel)
        
        return request
    }
}
