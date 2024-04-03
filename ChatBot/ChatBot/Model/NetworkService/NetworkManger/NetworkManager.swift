import Foundation
import Combine

class NetworkManager: Fetchable {
    
    func fetchChatGPTCompletionData<T: Decodable>(type: T.Type, with messages: [Message]) -> AnyPublisher<T, Error> {
        self.requestChatGPTCompletionData(with: messages)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func requestChatGPTCompletionData(with messages: [Message]) -> AnyPublisher<Data, Error> {
        guard let request = RequestProvider(requestInformation: .completion(model: .basic, messages: messages, logprobs: nil)).request else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299) ~= httpResponse.statusCode else {
                    throw NetworkError.requestFailed
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}
