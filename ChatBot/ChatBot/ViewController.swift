//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

class ViewController: UIViewController {
    private let networkManager = NetworkManager()
    private let api = ChatAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let response = jsonEncode()
        guard let request = api.makeRequest(body: response) else {
            print(NetworkError.invaildURL)
            return
        }
        
        networkManager.loadData(request: request) { result in
            switch result {
            case .success(let data):
                guard let decodeData = self.jsonDecode(data: data) else { return }
                print(decodeData)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func jsonEncode() -> Data? {
        let encoder = JSONEncoder()
        let messages = [Message(role: "user", content: "Say this is a test!", toolCalls: nil)]
        let data = ChatRequestModel(model: "gpt-3.5-turbo", messages: messages, stream: false, logprobs: false)
        do {
            let encodeData = try encoder.encode(data)
            return encodeData
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    private func jsonDecode(data: Data) -> ChatResponseModel? {
        do {
            let decodeData = try JSONDecoder().decode(ChatResponseModel.self, from: data)
            return decodeData
        } catch {
            print(error)
            return nil
        }
    }
}
