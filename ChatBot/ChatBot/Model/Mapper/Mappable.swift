import Foundation
import Combine

protocol Mappable {
    func mapChatGPTContent(with messages: [Message]) -> AnyPublisher<String, Error>
}
