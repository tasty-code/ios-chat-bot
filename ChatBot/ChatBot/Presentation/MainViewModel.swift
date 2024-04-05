import Combine
import Foundation

final class MainViewModel {
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userResponse: ChatCompletion? = nil
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
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        networkService.requestMessage(body: bodyData)
            .decode(type: OpenAI.Chat.ResponseDTO.self, decoder: decoder)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    guard let networkError = error as? NetworkError else { return }
                    self.networkError = networkError
                }
            } receiveValue: { responseDTO in
                let object = responseDTO.toDomain()
                self.userResponse = object
            }.store(in: &cancellables)
    }
}
