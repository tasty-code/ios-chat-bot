import Foundation

protocol NetworkBuilderProtocol {
    var baseURLString: String { get }
    var httpMethod: HTTPMethodType { get }
    var requestModel: Encodable { get }
    var httpHeaderFields: [String: String] { get }
    
    func build() throws -> URLRequest
}
