import Foundation

struct NetworkRequestBuilder: NetworkRequestBuilderProtocol {
    // MARK: Namespace
    enum NetworkBuilderError: Error {
        case buildRequestFailed
    }
    
    // MARK: Dependencies
    private let jsonEncodeManager: JSONEncodable
    
    // MARK: Public Properties
    let baseURLString: String
    let httpMethod: HTTPMethodType
    let httpHeaderFields: [String : String]
    let requestModel: Encodable
    
    // MARK: Life Cycle
    init(jsonEncodeManager: JSONEncodable, endpointType: EndpointType, httpMethod: HTTPMethodType, requestModel: Encodable) {
        self.jsonEncodeManager = jsonEncodeManager
        self.baseURLString = endpointType.baseURLString
        self.httpMethod = httpMethod
        self.httpHeaderFields = endpointType.header
        self.requestModel = requestModel
    }
    
    // MARK: Public Methods
    func build() throws -> URLRequest {
        guard let url = URL(string: baseURLString) else {
            throw NetworkBuilderError.buildRequestFailed
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.description
        request.allHTTPHeaderFields = httpHeaderFields
        request.httpBody = try jsonEncodeManager.encode(requestModel)
        
        return request
    }
}
