struct RequestModel: Encodable {
    let model: GPTModel
    let messages: [Message]
    let stream: Bool?
}

enum GPTModel: String, Encodable {
    case gpt_3_5_turbo = "gpt-3.5-turbo"
}
