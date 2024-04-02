import Foundation

enum RequestInformation {
    case completion(model: GPTModel, messages: [Message], Logprobs: Bool?)
    
    var url: URL? {
        switch self {
        case .completion:
            return Endpoint(apiHost: .chatGPT, urlInformation: .completion, scheme: .https).url
        }
    }
    
    var httpMethod: String {
        switch self {
        case .completion:
            return "POST"
        }
    }
    
    var allHTTPHeaderFields: [String : String] {
        switch self {
        case .completion:
            return [ "Content-Type" : "application/json",
                     "Authorization" : "Bearer API KEY" ]
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .completion(let model, let messages, let logprobs):
            let data = GPTRequestDTO(model: model, messages: messages, logprobs: logprobs)
            guard let uploadData = try? JSONEncoder().encode(data) else { return nil }
            return uploadData
        }
    }
}
