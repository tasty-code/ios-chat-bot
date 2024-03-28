import Foundation

enum JsonError: LocalizedError {
    case decodingError
    case encodingError
    
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return NSLocalizedString("Decoding error", comment: "")
        case .encodingError:
            return NSLocalizedString("Encoding error", comment: "")
        }
    }
}
