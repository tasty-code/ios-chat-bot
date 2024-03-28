struct ChatCompletionRequestDTO {
    let model: String
    let stream: Bool
    let messages: [Message]
}

extension ChatCompletionRequestDTO {
    struct Message {
        let role: String
        let content: String
    }
}
