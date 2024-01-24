//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit
import Combine


final class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    private let chatViewModel = ChatViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Layout
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 16.0
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private var contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.backgroundColor = .white
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private var inputTextView: UITextView = {
        let textView = UITextView()
        
        textView.isScrollEnabled = false
        
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        textView.backgroundColor = .systemBackground
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        
        return textView
    }()
    
    private var sendButton: UIButton = {
        let button = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        button.setImage(UIImage(systemName: "arrow.up.circle.fill", withConfiguration: imageConfig), for: .normal)
        button.tintColor = UIColor.systemMint
        
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return button
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        setupDelegates()
        setupRegistration()
        setupConfiguration()
    }
    
    // MARK: - Setup
    
    private func setupBinding() {
        let output = chatViewModel.subscribeAnswer()
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchChatDidStart(let isNetworking):
                    if isNetworking {
                        self?.collectionView.reloadData()
                    }
                case .fetchChatDidSucceed:
                    self?.collectionView.reloadData()
                }
            }.store(in: &cancellables)
    }
    
    private func setupDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
        inputTextView.delegate = self
        
        sendButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
    }
    
    private func setupRegistration() {
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: ChatMessageCell.identifier)
        collectionView.register(ChatLoadingBubbleCell.self, forCellWithReuseIdentifier: ChatLoadingBubbleCell.identifier)
    }
    
    private func setupConfiguration() {
        view.backgroundColor = .systemBackground
        view.addSubviews(collectionView, contentStackView)
        contentStackView.addArrangedSubviews(inputTextView, sendButton)
        
        NSLayoutConstraint.activate([
            sendButton.leadingAnchor.constraint(equalTo: inputTextView.trailingAnchor),
            inputTextView.widthAnchor.constraint(equalTo: sendButton.widthAnchor, multiplier: 6),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            contentStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func scrollToBottom() {
        let count = chatViewModel.getChatMessageCount()
        let indexPath = IndexPath(item: count - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    // MARK: - Event handler
    
    @objc func didTapSubmitButton() {
        inputTextView.resignFirstResponder()
        chatViewModel.userInputMessage.send(inputTextView.text)
        inputTextView.text = nil
        
        collectionView.reloadData()
    }
}

extension ChatViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chatViewModel.getChatMessageCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if chatViewModel.isNetworking, chatViewModel.messages[safeIndex: indexPath.row] == nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatLoadingBubbleCell.identifier, for: indexPath) as! ChatLoadingBubbleCell
            
            cell.loadingBubble.startAnimating()
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMessageCell.identifier, for: indexPath) as! ChatMessageCell
            
            cell.configure(model: chatViewModel, index: indexPath.row)
            
            scrollToBottom()
            return cell
        }
    }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let message = chatViewModel.getMessage(at: indexPath.row) else {
            return CGSize(width: view.bounds.width - 50, height: CGFloat(40))
        }
        
        let content = message.content
        let estimatedFrame = content.getEstimatedFrame(with: .systemFont(ofSize: 18))
        
        return CGSize(width: view.bounds.width - 50, height: estimatedFrame.height + 20)
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width - 30, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimateSize.height
            }
        }
    }
}

extension ChatViewController: UICollectionViewDelegate {}
