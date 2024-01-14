import Foundation

final class NetworkRequestBuilder: NetworkRequestBuilderProtocol {
    // MARK: Namespace
    enum NetworkBuilderError: Error {
        case buildRequestFailed
    }
    
    // MARK: Dependencies
    private let jsonEncodeManager: JSONEncodable
    
    // MARK: Private Properties
    var baseURLString: String
    var requestModel: Encodable? = nil
    var httpMethod: HTTPMethodType = .get
    var httpHeaderFields: [String : String] = [:]
    
    // MARK: Life Cycle
    init(jsonEncodeManager: JSONEncodable, endpoint: EndpointType) {
        self.jsonEncodeManager = jsonEncodeManager
        self.httpHeaderFields = endpoint.header
        self.baseURLString = endpoint.baseURLString
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
        guard let url = URL(string: (baseURLString)),
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
