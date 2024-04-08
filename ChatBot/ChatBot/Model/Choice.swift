
import Foundation

struct Choice: Codable {
    let index: Int
    let message: Message
    let logprobs: String?
    let finishReason: String
    
    enum CodingKeys: String, CodingKey {
        case index
        case message
        case logprobs
        case finishReason = "finish_reason"
    }
}
