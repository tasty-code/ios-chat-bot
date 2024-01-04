import Foundation

struct RequestModel: Codable {
    let model: String
    let messages: [Message]
    let stream: Bool?
}
