import Foundation
import Combine

protocol Fetchable {
    func fetchChatGPTCompletionData<T: Decodable>(with messages: [Message], type: T.Type) -> AnyPublisher<T, Error>
}

