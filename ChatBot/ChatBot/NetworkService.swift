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
}

extension OpenAINetworkManager {
    func sendMessage(messages: [OpenAI.Chat.RequestBodyDTO.Message]) -> AnyPublisher<OpenAI.Chat.ResponseDTO, Error> {
        let requestBody = OpenAI.Chat.RequestBodyDTO(messages: messages)
        
        let request = OpenAIRequest(
            baseURL: baseURL,
            path: basePath,
            /// Bearer -> API키를 노출시키지 않고, 클라이언트의 인증을 안전하게 수행하기 위함
            /// Bearer가 없을 경우 네트워크 통신이 안되는데
            /// 서버가 인증되지 않은 토큰이라고 판단해서 요청을 거부하는 경우 .......ㅎ
            headerParameters: ["Authorization": "Bearer \(apiKey)",
                               "Content-Type": "application/json"],
            bodyParameters: requestBody
        )
        
        guard let requestURL = request.toURLRequest() else {
            return Fail(error: NetworkError.generic("Failed to URL request" as! Error)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: requestURL)
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
