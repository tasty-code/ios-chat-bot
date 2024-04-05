import Combine
import Foundation

final class MainViewModel {
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userResponse: OpenAI.Chat.ResponseDTO? = nil
    @Published var networkError: NetworkError? = nil
    
    init(
        networkService: NetworkService
    ) {
        self.networkService = networkService
    }
    
    func sendMessage(
        content: String
    ) {
        let message = OpenAI.Chat.RequestBodyDTO.Message(role: .user, content: content)
        let bodyObject = OpenAI.Chat.RequestBodyDTO(messages: [message])
        let bodyData = try? JSONEncoder().encode(bodyObject)
        networkService.requestMessage(body: bodyData)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.networkError = error
                }
            } receiveValue: { response in
                self.userResponse = response
            }.store(in: &cancellables)
    }
}
