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
    
    // MARK: - Layout
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16.0
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    private var sendButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        
        button.setImage(UIImage(systemName: "arrow.up.circle.fill", withConfiguration: imageConfig), for: .normal)
        
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        
        return button
    }()
    
    lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 22
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        
        textView.isScrollEnabled = false
        textView.isEditable = true
        
        return textView
    }()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupDelegates()
        setupRegistration()
        setupSubviews()
        setupConstraint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.sendButtonDidTap(prompt: "Hello, My name is Janine. Please remember my name"))
    }
    
    // MARK: - Setup
    
    private func bind() {
        let output = chatViewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchChatDidStart:
                    self?.collectionView.reloadData()
                case .fetchChatDidSucceed:
                    self?.collectionView.reloadData()
                }
            }.store(in: &cancellables)
    }
    
    
    private func setupDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        inputTextView.delegate = self
        
        sendButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
    }
    
    private func setupRegistration() {
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.identifier)
        
        collectionView.register(LoadingIndicatorCell.self, forCellWithReuseIdentifier: LoadingIndicatorCell.identifier)
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
        view.addSubview(containerView)
        
        containerView.addSubview(sendButton)
        containerView.addSubview(inputTextView)
    }
    
    private func setupConstraint() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: inputTextView.heightAnchor),
            
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            sendButton.leadingAnchor.constraint(equalTo: inputTextView.trailingAnchor, constant: 10),
            sendButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            inputTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            inputTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            inputTextView.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -10)
        ])
    }
    
    
    // MARK: - Event handler
    
    @objc func didTapSubmit() {
        inputTextView.resignFirstResponder()
        input.send(.sendButtonDidTap(prompt: inputTextView.text))
        self.collectionView.reloadData()
    }
}

extension ChatViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatViewModel.getCountOfMessage()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if chatViewModel.isNetworking && indexPath.row == chatViewModel.messages.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingIndicatorCell.identifier, for: indexPath) as! LoadingIndicatorCell
            
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
            return CGSize(width: view.bounds.width, height: view.bounds.height)
        }
        
        let content = message.content
        let estimatedFrame = content.getEstimatedFrame(with: .systemFont(ofSize: 18))
        return CGSize(width: view.bounds.width, height: estimatedFrame.height + 20)
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
