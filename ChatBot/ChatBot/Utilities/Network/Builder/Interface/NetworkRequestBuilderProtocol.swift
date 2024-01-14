import Foundation

protocol NetworkRequestBuilderProtocol {
    var baseURLString: String { get set }
    var httpMethod: HTTPMethodType { get set }
    var requestModel: Encodable? { get set }
    var httpHeaderFields: [String: String] { get set }
    
    func setHttpMethod(httpMethod: HTTPMethodType)
    func setHttpHeaderFields(httpHeaderFields: [String: String])
    func setRequestModel(requestModel: RequestModel)
    func build() throws -> URLRequest
}

extension NetworkRequestBuilderProtocol {
    mutating func setHttpMethod(httpMethod: HTTPMethodType) {
        self.httpMethod = httpMethod
    }
    
    mutating func setHttpHeaderFields(httpHeaderFields: [String: String]) {
        self.httpHeaderFields = httpHeaderFields
    }
    
    mutating func setRequestModel(requestModel: RequestModel) {
        self.requestModel = requestModel
    }
}
