
import Foundation

// MARK: - Request
struct ChatBotRequest: Encodable {
    let model: String
    let stream: Bool
    let messages: [Message]
}

struct Message: Codable {
    let role, content: String
}

// MARK: - Response
struct ChatBotResponse: Decodable {
    let id, object: String
    let created: Int
    let model, systemFingerprint: String
    let choices: [Choice]
    let usage: Usage

    enum CodingKeys: String, CodingKey {
        case id, object, created, model
        case systemFingerprint = "system_fingerprint"
        case choices, usage
    }
}

struct Choice: Decodable {
    let index: Int
    let message: Message
    let finishReason: String

    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

struct Usage: Codable {
    let promptTokens, completionTokens, totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
