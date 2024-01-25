//
//  ChattingViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class ChattingViewController: UIViewController {
    
    private let chatService = ChatService(url: OpenAIURL(path: .chat), httpMethod: .post, contentType: .json)

    private lazy var collectionView: ChatCollectionView = {
        let collectionView = ChatCollectionView(frame: .zero)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.chatServiceDelegate = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionViewConfigure()
        self.collectionView.allowsSelection = false
    }
    
    private func collectionViewConfigure() {
        let safeArea = view.safeAreaLayoutGuide
        let chatTextInputView = ChatTextInputView()
        chatTextInputView.delegate = collectionView
        
        view.addSubview(collectionView)
        view.addSubview(chatTextInputView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: chatTextInputView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            chatTextInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            chatTextInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            chatTextInputView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -8),
        ])
    }
}

extension ChattingViewController: ChatServiceDelegate  {
    func injectChatServiceDelegate() -> ChatService {
        return chatService
    }
}
