import Foundation
import Combine

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case dataError
}

final class OpenAINetworkManager {
    private let apiKey: String
    private let baseURL = "api.openai.com"
    private let basePath = "/v1/chat/completions"
    private let jsonDecoder: JSONDecoder
    
    init(
        apiKey: String = Bundle.main.apiKey,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiKey = apiKey
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.jsonDecoder = decoder
    }
    
    private func makeRequest(messages: [OpenAI.Chat.RequestBodyDTO.Message]) -> URLRequest? {
        let requestBody = OpenAI.Chat.RequestBodyDTO(messages: messages)
        
        let request = OpenAIRequest(
            baseURL: baseURL,
            path: basePath,
            headerParameters: ["Authorization": "Bearer \(apiKey)",
                               "Content-Type": "application/json"],
            bodyParameters: requestBody
        )
        return request.toURLRequest()
    }
    
    func requestMessage(messages: [OpenAI.Chat.RequestBodyDTO.Message]) -> AnyPublisher<OpenAI.Chat.ResponseDTO, NetworkError> {
        guard let request = makeRequest(messages: messages) else {
            return Fail(error: NetworkError.generic("Failed to create URL request" as! Error)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.notConnected
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.error(statusCode: httpResponse.statusCode, data: data)
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
