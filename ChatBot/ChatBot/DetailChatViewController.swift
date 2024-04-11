//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class DetailChatViewController: UIViewController {
    // MARK: - Property

    private var viewModel: ChatViewModel
    private var repo: MessageRepository
    private let apiService: OpenAIService
    
    private var detailChatStackView: UIStackView = DetailChatViewUserInputSectionStackView()

    
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
    
    // MARK: - CustomFunc
    private func configureDetailChatStackView() {
        if let stackView = detailChatStackView as? DetailChatViewUserInputSectionStackView {
            stackView.userInputTextView.delegate = self
        }
        self.view.addSubview(detailChatStackView)
        detailChatStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailChatStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            detailChatStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            detailChatStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailChatStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

}

extension DetailChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width - 40, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let validHeight = estimatedSize.height.isNaN || estimatedSize.height < 0 ? 40 : estimatedSize.height
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = max(40, min(100, validHeight))
            }
        }
    }
}
