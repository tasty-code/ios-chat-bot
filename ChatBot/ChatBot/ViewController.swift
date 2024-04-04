//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

class ChatbotMainViewController: UIViewController {
    private var viewModel: ChatViewModel
    private var repo: MessageRepository
    private let apiService: OpenAIService
    
    init(viewModel: ChatViewModel, repo: MessageRepository, apiService: OpenAIService) {
        self.apiService = apiService
        self.viewModel = viewModel
        self.repo = repo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repo = MessageRepository()
        
        viewModel = ChatViewModel(repository: repo, apiService: apiService)
        
        setupSendMessageButton()
        setupCheckStoregeButton()
        setupclearRepoButton()
        setupErrorAlert()
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
    
    private func configuerErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error발생", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
    
    private func setupErrorAlert() {
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.configuerErrorAlert(message: errorMessage)
            }
        }
    }
    
    // MARK: - objc func
    @objc private func sendMessage() {
        let message = "IOS 개발자가 되기 위한 구체적인 계획"
        
        DispatchQueue.main.async {
            self.viewModel.processUserMessage(message: message, model: .gpt3Turbo)
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
