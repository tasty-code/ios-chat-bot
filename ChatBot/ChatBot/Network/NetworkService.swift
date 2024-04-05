import Foundation
import Combine

final class NetworkService {
    private let requester: NetworkRequestable
    
    init(
        requester: NetworkRequestable
    ) {
        self.requester = requester
    }
    
    private func makeRequest(body: Data?) -> URLRequest? {
        let request = OpenAIRequest(body: body)
        return request.toURLRequest()
    }
    
    func requestMessage(
        body: Data?
    ) -> AnyPublisher<Data, NetworkError> {
        guard 
            let request = makeRequest(body: body)
        else {
            let error = NetworkError.generic("Failed to create URL request" as! Error)
            return Fail(error: error)
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
            .mapError { error -> NetworkError in
                if let decodingError = error as? DecodingError {
                    return .generic(decodingError)
                } else {
                    return .generic(error)
                }
            }.eraseToAnyPublisher()
    }
}
