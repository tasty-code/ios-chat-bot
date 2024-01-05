import UIKit

class APIService {
    
    func fetchMessageForPrompt(_ prompt: String) async throws -> String {
        let fetchMessageURL = "https://api.openai.com/v1/chat/completions"
        
        let urlRequest = try createURLRequestFor(httpMethod: "POST", url: fetchMessageURL, prompt: prompt)
        
        let (data, response)  = try await URLSession.shared.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        
        let result = try decoder.decode(APIResponse.self, from: data)
        
        let content = result.choices[0].message.content
        
        return content
    }
    
    
    private func createURLRequestFor(httpMethod: String, url: String, prompt: String) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw APIError.unableToCreateURLForURLRequest
        }
        
        var urlRequest = URLRequest(url: url)
        
        
        urlRequest.httpMethod = httpMethod
        
        urlRequest.addValue("Bearer \(Environment.apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody: [String: Any] = [
            "model": "gpt-3.5-turbo-1106",
            "stream": false,
            "messages": [
                [
                    "role": "system",
                    "content": "You are an assistant that occasionally misspells words"
                ],
                [
                    "role": "user",
                    "content": "\(prompt)"
                ]
            ]
        ]
        
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
        
        return urlRequest
    }
    
    private func fetchDataResponse() {
        
    }
}
