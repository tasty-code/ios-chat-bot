//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class ViewController: UIViewController {
    let networkService = APIService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMessageForPrompt(prompt: "Tell me a story")
    }
 
    private func fetchMessageForPrompt(prompt: String) {
        let request = PostChatBotNetworkBuilder(prompt: prompt)
        guard let makeRequest = try? networkService.makeRequest(request) else {
            return
        }
        
        Task {
            do {
                let message: APIResponse = try await networkService.execute(request: makeRequest)
                print(message.choices[0].message.content)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
