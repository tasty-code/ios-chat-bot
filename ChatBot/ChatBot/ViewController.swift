//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

class ViewController: UIViewController {
    private var viewModel: ChatViewModel!
    private var repo: MessageRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSendMessageButton()
        setupCheckStoregeButton()
        setupclearRepoButton()
    }
    
    // MARK: - func
    private func setupSendMessageButton() {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send Message", for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupCheckStoregeButton() {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("checkStorege", for: .normal)
        sendButton.addTarget(self, action: #selector(printMessageRepositoryContents), for: .touchUpInside)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40)
        ])
    }
    
    private func setupclearRepoButton() {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("clearRepo", for: .normal)
        sendButton.addTarget(self, action: #selector(messageClear), for: .touchUpInside)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80)
        ])
    }
    
    // MARK: - objc func
    @objc private func sendMessage() {
        let message = "IOS 개발자가 되기 위한 구체적인 계획"
        DispatchQueue.main.async {
            self.viewModel.processUserMessage(message)
        }
    }
    @objc private func printMessageRepositoryContents() {
        let messages = repo.getMessages()
         print("""
         😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃
         \(messages)
         😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃
         """)
     }
     @objc private func messageClear() {
         repo.clearStorage()
      }
}
