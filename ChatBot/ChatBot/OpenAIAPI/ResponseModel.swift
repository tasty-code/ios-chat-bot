import Foundation

struct ResponseModel: Decodable {
    let id, object: String?
    let created: Int?
    let model, systemFingerprint: String?
    let choices: [Choice]?
    let usage: Usage?

    enum CodingKeys: String, CodingKey {
        case id, object, created, model
        case systemFingerprint = "system_fingerprint"
        case choices, usage
    }
}

struct Choice: Decodable {
    let index: Int?
    let message: Message?
    let finishReason: String?

    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

struct Message: Codable {
    let role: Role?
    let content: String?
}

enum Role: String, Codable {
    case system = "system"
    case user = "user"
    case assistant = "assistant"
}

struct Usage: Decodable {
    let promptTokens, completionTokens, totalTokens: Int?

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
