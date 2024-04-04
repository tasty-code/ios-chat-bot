import Foundation
import Combine

final class NetworkManager {
    private let jsonDecoder: JSONDecoder
    
    init(
        decoder: JSONDecoder
    ) {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.jsonDecoder = decoder
    }
    
    private func makeRequest(messages: [OpenAI.Chat.RequestBodyDTO.Message]) -> URLRequest? {
        let requestBody = OpenAI.Chat.RequestBodyDTO(messages: messages)
        let request = OpenAIRequest(body: try? JSONEncoder().encode(requestBody))
        return request.toURLRequest()
    }
    
    func requestMessage(
        messages: [OpenAI.Chat.RequestBodyDTO.Message]
    ) -> AnyPublisher<OpenAI.Chat.ResponseDTO, NetworkError> {
        guard let request = makeRequest(messages: messages) else {
            return Fail(error: NetworkError.generic("Failed to create URL request" as! Error)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.notConnected
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.httpResponse(statusCode: httpResponse.statusCode, data: data)
                }
                return data
            }
            .decode(type: OpenAI.Chat.ResponseDTO.self, decoder: jsonDecoder)
            .mapError { error -> NetworkError in
                if let decodingError = error as? DecodingError {
                    return .generic(decodingError)
                } else {
                    return .generic(error)
                }
            }.eraseToAnyPublisher()
    }
}
