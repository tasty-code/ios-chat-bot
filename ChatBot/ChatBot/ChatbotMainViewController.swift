//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class ChatbotMainViewController: UIViewController {
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
    }
}
