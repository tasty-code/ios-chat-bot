import Combine
import Foundation

final class MainViewModel {
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userResponse: OpenAI.Chat.ResponseDTO? = nil
    @Published var systemResponse: OpenAI.Chat.ResponseDTO? = nil
    @Published var networkError: NetworkError? = nil
    
    init(
        networkService: NetworkService
    ) {
        self.networkService = networkService
    }
    
    func sendMessage(
        role: OpenAI.Chat.RequestBodyDTO.Message.Role,
        content: String
    ) {
        let message = OpenAI.Chat.RequestBodyDTO.Message(role: role, content: content)
        networkService.requestMessage(messages: [message])
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.networkError = error
                }
            } receiveValue: { response in
                switch role {
                case .system:
                    self.systemResponse = response
                case .user:
                    self.userResponse = response
                default:
                    break
                }
            }.store(in: &cancellables)
    }
}
