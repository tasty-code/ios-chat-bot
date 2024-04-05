import Foundation
import Combine

final class NetworkService {
    private let requester: NetworkRequestable
    private let jsonDecoder: JSONDecoder
    
    init(
        requester: NetworkRequestable,
        decoder: JSONDecoder
    ) {
        self.requester = requester
        self.jsonDecoder = decoder
    }
    
    private func makeRequest(body: Data?) -> URLRequest? {
        let request = OpenAIRequest(body: body)
        return request.toURLRequest()
    }
    
    func requestMessage(
        body: Data?
    ) -> AnyPublisher<OpenAI.Chat.ResponseDTO, NetworkError> {
        guard let request = makeRequest(body: body) else {
            return Fail(error: NetworkError.generic("Failed to create URL request" as! Error))
                .eraseToAnyPublisher()
        }
        
        return requester.dataTaskPublisher(for: request)
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
