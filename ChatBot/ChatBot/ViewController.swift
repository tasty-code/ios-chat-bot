//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chatService = ChatService()
        try? chatService.sendMessage(text: "안녕") { result in
            switch result {
            case .success(let success):
                print("GPT: \(success.choices[0].message.content)")
            case .failure(let error):
                print(error)
            }
        }
    }
}
