
import XCTest

@testable import ChatBot

final class ChatBotTests: XCTestCase {
    
    func test_네트워크_테스트() throws {
        let session = URLSession(configuration: .default)
        
        //MARK: - HTTP Request Message 만들기
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Key", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let msg1 = Message(role: "user", content: "안녕")
        let request = ChatBotRequest(model: "gpt-3.5-turbo-1106",
                                     stream: false,
                                     messages: [msg1])
        urlRequest.httpBody = try JSONEncoder().encode(request)
        print(urlRequest.httpBody)
        print(urlRequest.allHTTPHeaderFields)
        let expectation = XCTestExpectation(description: "dataFectch")
        
        //MARK: - Request 보내고 응답받기
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            
            if let data = data, let httpReponse = response as? HTTPURLResponse, 
                httpReponse.statusCode == 200 {
                do {
                    let chatBotResponse = try JSONDecoder().decode(ChatBotResponse.self, from: data)
                    print(chatBotResponse.choices.last?.message)
                } catch {
                    // 에러
                    print(error)
                }
                
                
            } else {
                print(response)
            }
        }.resume()
        wait(for: [expectation], timeout: 10)
    }
}

