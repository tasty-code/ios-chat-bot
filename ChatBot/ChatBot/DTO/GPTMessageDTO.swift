import Foundation

// MARK: - Message
struct Message: Codable {
    let role: Role
    let content: String?
    let toolCalls: [ToolCall]?
    
    private enum CodingKeys: String, CodingKey {
            case content, role
            case toolCalls = "tool_calls"
    }
}

struct ToolCall: Codable {
    let id, type: String
    let function: Function
}

struct Function: Codable {
    let name, arguments: String
}
