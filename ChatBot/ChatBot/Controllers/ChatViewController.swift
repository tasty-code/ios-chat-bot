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
    
    private let input: PassthroughSubject<ChatViewModel.InputEvent, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var textViewMaxHeightConstraint: NSLayoutConstraint =
    inputTextView.heightAnchor.constraint(equalToConstant: view.frame.height / 9)
    
    // MARK: - Layout
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 16.0 // 위아래 줄 간격
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .onDrag
        view.addSubview(collectionView)
        
        return collectionView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            inputTextView, sendButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.backgroundColor = .white
        stackView.spacing = 15
        view.addSubview(stackView)
        
        return stackView
    }()
    
    private lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 12
        textView.layer.borderColor = UIColor.systemMint.cgColor
        textView.layer.borderWidth = 1
        textView.backgroundColor = .white
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        button.setImage(UIImage(systemName: "arrow.up.circle.fill", withConfiguration: imageConfig), for: .normal)
        button.tintColor = UIColor.systemMint
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        setupDelegates()
        setupRegistration()
        
        setupConstraint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        input.send(.sendButtonDidTap(prompt: "Hello, My name is Janine. Please remember my name"))
    }
    
    
    // MARK: - Setup
    
    private func bind() {
        let output = chatViewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchRequestDidCreate:
                    self?.collectionView.reloadData()
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
    }
    
    private func setupRegistration() {
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.identifier)
        
        collectionView.register(ChatLoadingBubbleCell.self, forCellWithReuseIdentifier: ChatLoadingBubbleCell.identifier)
    }
    
    private func setupConstraint() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputTextView.widthAnchor.constraint(equalTo: sendButton.widthAnchor, multiplier: 6),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    // MARK: - Event handler
    
    @objc func didTapSubmitButton() {
        inputTextView.resignFirstResponder()
        input.send(.sendButtonDidTap(prompt: inputTextView.text))
        inputTextView.text = nil
        
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.identifier, for: indexPath) as! ChatCollectionViewCell
            
            cell.configure(model: chatViewModel, index: indexPath.row)
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

extension ChatViewController: UICollectionViewDelegate { }
