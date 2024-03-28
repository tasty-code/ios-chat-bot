import Foundation

struct ChatCompletionRequestDTO {
    let model: String
    let messages: [Message]
    let stream: Bool?
    let maxTokens: Int?
    let tools: [Tool]?
}

extension ChatCompletionRequestDTO {
    struct Message {
        let role: String
        let name: String?
        let content: String
        let tools: [Tool]?
        let functionCall: Function?
        let toolCallId: String?
    }
}
extension ChatCompletionRequestDTO {
    struct Tool {
        let type: String
        let function: Function
    }
}

extension ChatCompletionRequestDTO {
    struct Function {
        let name: String
        let description: String
        let parmeters: Parameter
    }
}

extension ChatCompletionRequestDTO.Function {
    struct Parameter {
        let location: Location
        let unit: Unit
    }
}

extension ChatCompletionRequestDTO.Function.Parameter {
    struct Location {
        let type: String
        let description: String
    }
}


extension ChatCompletionRequestDTO.Tool {
    struct Function {
        let name: String
        let arguments: String
    }
}


