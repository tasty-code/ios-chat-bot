import Foundation

enum URLInfomation {
    case completion
    
    var path: String {
        switch self {
        case .completion:
            return "/v1/chat/completions"
        }
    }
    
    var queryItem: [URLQueryItem]? {
        let urlQueryItems: [URLQueryItem]? = nil
        
        switch self {
        case .completion:
            return urlQueryItems
        }
    }
}
