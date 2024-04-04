extension OpenAI.Chat {
    struct RequestBodyDTO: Encodable  {
        let model: String = "gpt-3.5-turbo-1106"
        let stream: Bool = false
        let messages: [Message]
    }
}

extension OpenAI.Chat.RequestBodyDTO {
    struct Message: Encodable {
        let role: String
        let content: String
    }
}
enum Role: String {
    case user
    case system
}
