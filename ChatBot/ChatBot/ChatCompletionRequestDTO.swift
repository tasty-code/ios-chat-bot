struct ChatCompletionRequestDTO: Encodable  {
    let model: String
    let stream: Bool
    let messages: [Message]
}

extension ChatCompletionRequestDTO {
    struct Message: Encodable  {
        let role: String
        let content: String
    }
}
