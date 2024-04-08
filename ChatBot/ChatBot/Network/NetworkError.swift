
import Foundation

enum NetworkError: Error {
    case urlError
    case dataError
    case decoderError
    case requestError
    case invalidResponse
    
    var errorMessage: String {
        switch self {
        case .urlError:
            return "URL 에러 입니다."
        case .dataError:
            return "데이터 에러 입니다."
        case .decoderError:
            return "JSON 에러 입니다"
        case .requestError:
            return "request 에러 입니다."
        case .invalidResponse:
            return "invalidResponse 에러 입니다."
        }
    }
}
