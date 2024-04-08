import Foundation
import Combine

protocol DataDecodable {
    func decodedChatGPTCompletionData<T: Decodable>(with messages: [Message], type: T.Type) -> AnyPublisher<T, Error>
}
