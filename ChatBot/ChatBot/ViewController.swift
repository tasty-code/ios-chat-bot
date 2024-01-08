//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class ViewController: UIViewController {
    private let networkManager = NetworkManager()
    private let api = ChatAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let response = jsonEncode()
        
        Task {
            do {
                let request = try await api.makeRequest(body: response)
                let data = try await networkManager.loadData(request: request)
                print(data)
            } catch {
                print(error)
            }
        }
    }
    
    private func jsonEncode() -> Data? {
        let encoder = JSONEncoder()
        let messages = [Message(role: "user", content: "안녕 넌 누구야?", toolCalls: nil)]
        let data = ChatRequestModel(model: "gpt-3.5-turbo", messages: messages, stream: false, logprobs: false)
        do {
            let encodeData = try encoder.encode(data)
            return encodeData
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
