
import Foundation

struct NetworkManger {
    
    let apiKey = Bundle.main.OPENAI_API_KEY
  
    func UrlComponents() -> URL?{
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openai.com"
        urlComponents.path = "/v1/chat/completions"
        
        return urlComponents.url
    }

    func UrlRequset() -> URLRequest? {
        guard let url = UrlComponents() else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let header = ["Authorization": "Bearer \(apiKey)"]
        request.allHTTPHeaderFields = header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let bodyData = ChatRequest(messages: [.init(role: "system", content: "어렵다"),Message(role: "user", content: "swift언어 설명해줘 ")])
        
        guard let body = try? JSONEncoder().encode(bodyData) else {
            return nil
        }
        request.httpBody = body
        
        return request
        
    }
    
    func DecodedData<T: Codable>(data: Data?) -> (Result<T, NetworkError>) {
        guard
            let data = data
        else {
            return .failure(.dataError)
        }
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            print("Decoding failed with error:", error)
            return .failure(.decoderError)
        }
    }
    
    func urlDataTaks(completion: @escaping (Result<Data, Error>) -> Void)  {
        guard let request = UrlRequset() else {
            completion(.failure(NetworkError.urlError))
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(.failure(NetworkError.dataError))
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.dataError))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
