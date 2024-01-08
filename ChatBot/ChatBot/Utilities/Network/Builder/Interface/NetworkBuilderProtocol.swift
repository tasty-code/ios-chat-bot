import Foundation

protocol NetworkBuilderProtocol {
    var baseURLString: String { get }
    var httpMethod: HTTPMethodType { get }
    var requestModel: Encodable { get }
    var httpHeaderFields: [String: String] { get }
    var jsonEncodeManager: JSONEncodable { get }
    
    func build() throws -> URLRequest
}

extension NetworkBuilderProtocol {
    var jsonEncodeManager: JSONEncodable {
        JSONEncodeManager()
    }
}
