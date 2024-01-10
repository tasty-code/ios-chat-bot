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
                let request = try api.makeRequest(body: body)
                let responseModel = try await networkManager.loadData(request: request)
                guard let msg = responseModel.choices.first?.message.content else {return}
                
                print("답변: \n", msg)
                
            } catch {
                print(error)
            }
        }
    }
    
    private func makeRequestModel() -> ChatRequestModel {
        let messages = [
            Message(
                role: "user",
                content: "swift언어의 특징이 뭐야?",
                toolCalls: nil)]
        
        let model = ChatRequestModel(model: "gpt-3.5-turbo-1106",
                                    messages: messages,
                                    stream: false,
                                    logprobs: false)
        
        return model
    }
}
