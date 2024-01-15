//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class ViewController: UIViewController {
    
    private let chatService = ChatService(url: OpenAIURL(path: .chat), httpMethod: .post, contentType: .json)
    private lazy var chatStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var collectionView: ChatCollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let collectionView = ChatCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.chatServiceDelegate = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewConfigure()
    }
    
    private func collectionViewConfigure() {
        let safeArea = view.safeAreaLayoutGuide
        let chatTextInputView = ChatTextInputView()
        chatTextInputView.delegate = collectionView
        
        view.addSubview(chatStackView)
        chatStackView.addArrangedSubview(collectionView)
        chatStackView.addArrangedSubview(chatTextInputView)
        
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: chatStackView.widthAnchor, multiplier: 1.0),
            chatStackView.topAnchor.constraint(equalTo: view.topAnchor),
            chatStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            chatStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatTextInputView.leadingAnchor.constraint(equalTo: chatStackView.leadingAnchor, constant: 8),
            chatTextInputView.trailingAnchor.constraint(equalTo: chatStackView.trailingAnchor, constant: -8)
        ])
    }
}

extension ViewController: ChatServiceDelegate  {
    func injectChatServiceDelegate() -> ChatService {
        return chatService
    }
}
