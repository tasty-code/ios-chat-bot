import Foundation
import Combine

final class DataDecoder: DataDecodable {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func decodedChatGPTCompletionData<T: Decodable>(with messages: [Message], type: T.Type) -> AnyPublisher<T, Error> {
        networkManager.requestChatGPTCompletionData(with: messages)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
