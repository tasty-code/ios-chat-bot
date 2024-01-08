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
        
        let requestModel = makeRequestModel()
        Task {
            do {
                let body = try JSONEncoder().encode(requestModel)
                let request = try await api.makeRequest(body: body)
                let responseModel = try await networkManager.loadData(request: request)
                
                print(responseModel)
            } catch {
                print(error)
            }
        }
    }
    
    private func makeRequestModel() -> ChatRequestModel {
        let messages = [Message(role: "user",
                                content: "안녕 넌 누구야?",
                                toolCalls: nil)]
        
        let model = ChatRequestModel(model: "gpt-3.5-turbo",
                                    messages: messages,
                                    stream: false,
                                    logprobs: false)
        
        return model
    }
}
