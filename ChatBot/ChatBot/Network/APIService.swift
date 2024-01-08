import UIKit

final class APIService {
    
    func execute<Response:Decodable>(request: URLRequest) async throws -> Response {
        
        let (data, httpResponse) = try await URLSession.shared.data(for: request)
        
        guard let response = httpResponse as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidResponse(code: (httpResponse as? HTTPURLResponse)?.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Response.self, from: data)
            
            return result
        } catch {
            throw APIError.failToDecodeData
        }
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
