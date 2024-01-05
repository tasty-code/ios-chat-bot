//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class ViewController: UIViewController {
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMessageForPrompt(prompt: "Tell me a story")
    }
 
    private func fetchMessageForPrompt(prompt: String) {
        Task {
            do {
                let message = try await APIService().fetchMessageForPrompt(prompt)
                    print(message)
            } catch {
                print("Error")
            }
        }
    }
}
