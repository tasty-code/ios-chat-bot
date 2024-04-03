import Combine
import Foundation

final class ChatViewModel {
    private let networkManager: OpenAINetworkManager
    private var cancellables = Set<AnyCancellable>()
    
    init(networkManager: OpenAINetworkManager) {
        self.networkManager = networkManager
    }
    
    func sendMessage(role: String, content: String) -> AnyPublisher<String, Error> {
        let message = OpenAI.Chat.RequestBodyDTO.Message(role: role, content: content)
        return networkManager.sendMessage(messages: [message])
        /// tryMap + mapError -> try-catch와 유사
        /// 에러 발견하면 publish 종료
            .tryMap { response in
                guard let firstChoice = response.choices.first,
                      let content = firstChoice.message.content else {
                    throw NetworkError.dataError
                }
                return content
            }
        /// 발생한 에러 NetworkError로 매핑함
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.generic(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

