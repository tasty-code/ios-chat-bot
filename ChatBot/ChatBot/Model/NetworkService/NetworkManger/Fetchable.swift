import Foundation
import Combine

protocol Fetchable {
    func fetchChatGPTCompletionData<T: Decodable>(type: T.Type, with messages: [Message]) -> AnyPublisher<T, Error>
}

