import Foundation

struct ChatBotRequestDTO: Encodable {
    let model: String
    let stream: Bool
    let messages: [MessageDTO]
}

