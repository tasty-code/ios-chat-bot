import Foundation

enum NetworkError: Error {
    case httpResponse(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case dataError
    case generic(Error)
}
