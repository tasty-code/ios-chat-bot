import Foundation

// MARK: - GPTRequestDTO
struct GPTRequestDTO: Codable {
    let model: GPTModel
    let messages: [Message]
    let logprobs: Bool?
    
    enum CodingKeys: String, CodingKey {
        case model, messages, logprobs
    }
}

