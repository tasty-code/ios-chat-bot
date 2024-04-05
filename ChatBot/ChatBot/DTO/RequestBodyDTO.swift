extension OpenAI.Chat {
    struct RequestBodyDTO: Encodable  {
        let model: String = "gpt-3.5-turbo-1106"
        let stream: Bool = false
        let messages: [Message]
    }
}

extension OpenAI.Chat.RequestBodyDTO {
    struct Message: Encodable {
        let role: Role
        let content: String
    }
}

extension OpenAI.Chat.RequestBodyDTO.Message {
    enum Key: CodingKey {
        case role
        case content
    }
    
    enum Role: String {
        case system
        case assistant
        case user
    }
}

extension OpenAI.Chat.RequestBodyDTO.Message {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(self.role.rawValue, forKey: .role)
        try container.encode(self.content, forKey: .content)
    }
}
