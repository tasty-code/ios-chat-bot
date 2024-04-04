import Combine
import Foundation

final class ChatViewModel {
    let networkManager: OpenAINetworkManager
    private var cancellables = Set<AnyCancellable>()
    @Published var userResponse: OpenAI.Chat.ResponseDTO? = nil
    @Published var systemResponse: OpenAI.Chat.ResponseDTO? = nil
    @Published var networkError: NetworkError? = nil
    
    init(networkManager: OpenAINetworkManager) {
        self.networkManager = networkManager
    }
    
    func sendMessage(role: String, content: String) {
        let message = OpenAI.Chat.RequestBodyDTO.Message(role: role, content: content)
        networkManager.requestMessage(messages: [message])
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.networkError = error
                }
            } receiveValue: { response in
                if role == Role.user.rawValue {
                    self.userResponse = response
                } else {
                    self.systemResponse = response
                }
            }.store(in: &cancellables)
    }
}
