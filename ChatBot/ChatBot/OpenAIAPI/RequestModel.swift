import Foundation

struct RequestModel: Encodable {
    let model: String
    let messages: [Message]
    let stream: Bool?
}
