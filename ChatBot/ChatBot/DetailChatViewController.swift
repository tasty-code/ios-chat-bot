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
    private var chatMessageCollectionView = ChatMessageCollectionView()

    
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
        self.view.backgroundColor = .white
        configureDetailChatStackView()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        keyboardAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       keyboardDisappear()
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
    
    private func configureCollectionView() {
        view.addSubview(chatMessageCollectionView)
           chatMessageCollectionView.dataSource = self
           chatMessageCollectionView.delegate = self
        
        NSLayoutConstraint.activate([
            chatMessageCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            chatMessageCollectionView.leadingAnchor.constraint(equalTo: detailChatStackView.leadingAnchor),
            chatMessageCollectionView.trailingAnchor.constraint(equalTo: detailChatStackView.trailingAnchor),
            chatMessageCollectionView.bottomAnchor.constraint(equalTo: detailChatStackView.topAnchor, constant: -10)
        ])
    }
    // MARK: - keyBoardAction
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        self.view.transform = .identity
    }
    
    private func keyboardAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func keyboardDisappear() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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

// MARK: - CollectionView

extension DetailChatViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    }
    
    
}

