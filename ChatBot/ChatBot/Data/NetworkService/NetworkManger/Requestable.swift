import Foundation
import Combine

protocol Requestable {
    func requestChatGPTCompletionData(with messages: [Message]) -> AnyPublisher<Data, Error>
}
