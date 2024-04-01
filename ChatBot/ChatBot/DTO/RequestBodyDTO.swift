extension OpenAI.Chat {
    struct RequestBodyDTO: Encodable  {
        let model: String
        let stream: Bool
        let messages: [Message]
    }
}

extension OpenAI.Chat.RequestBodyDTO {
    struct Message: Encodable  {
        let role: String
        let content: String
    }
}
