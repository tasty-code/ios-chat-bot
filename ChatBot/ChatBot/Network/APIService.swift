import UIKit
import Combine

final class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    func execute<Response: Decodable>(request: URLRequest) -> AnyPublisher<Response, Error> {
        URLSession.shared.dataTaskPublisher(with: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw APIError.invalidResponse(
                        code: (response as? HTTPURLResponse)?.statusCode)
                }
                
                return data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func makeRequest<Builder: NetworkRequestBuildable>(_ builder: Builder) throws -> URLRequest {
        guard let baseURL = URL(string: builder.baseURL) else {
            throw APIError.unableToCreateURLForURLRequest
        }
        
        let url = baseURL.appendingPathComponent(builder.path)
        
        var request = URLRequest(url: url)
        request.httpMethod = builder.httpMethod.rawValue
        
        builder.headers.forEach { (key, value) in
            request.setValue(value as? String, forHTTPHeaderField: key)
        }
        
        if let authKey = builder.authKey {
            request.setValue("Bearer \(authKey)", forHTTPHeaderField: "Authorization")
        }
        
        request.setValue(builder.contentType, forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(builder.body)
        
        return request
    }
}
