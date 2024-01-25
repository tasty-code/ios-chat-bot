//
//  ChatViewController.swift
//  ChatBot
//
//  Created by 김예준 on 1/9/24.
//

import UIKit

final class ChatViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.keyboardDismissMode = .onDrag
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentHuggingPriority(.required, for: .horizontal)
        return stackView
    }()
    
    private lazy var sendButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(sendButton)
        return stackView
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 16
        textView.layer.borderWidth = 1.5
        textView.layer.borderColor = UIColor.red.cgColor
        textView.isScrollEnabled = true
        textView.delegate = self
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 16
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()
    
    typealias ChatDataSource = UICollectionViewDiffableDataSource<Int, Chat>
    typealias CellRegistration = UICollectionView.CellRegistration<ChatCollectionViewCell, Chat>
    
    private var dataSource: ChatDataSource!
    private var cellRegistration: CellRegistration!
    
    private let networkManager = NetworkManager()
    private let api = ChatAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayouts()
        setConstraints()
        configureDataSource()
        configureCellRegistration()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        collectionView.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Configure Layout

extension ChatViewController {
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func setUpLayouts() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        view.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubviews([textView, sendButtonStackView])
        
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    private func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor),
            
            sendButton.widthAnchor.constraint(equalToConstant: 35),
            sendButton.heightAnchor.constraint(equalToConstant: 35),
            
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            horizontalStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            horizontalStackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -30),
            sendButton.topAnchor.constraint(equalTo: horizontalStackView.centerYAnchor, constant: -17),
            
            textView.heightAnchor.constraint(equalToConstant: textView.estimatedSizeHeight),
            textView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -71)
        ])
    }
}

// MARK: - Configure Data

extension ChatViewController {
    
    private func configureDataSource() {
        dataSource = ChatDataSource(collectionView: collectionView) { (collectionView, indexPath, identifier) -> ChatCollectionViewCell? in
            collectionView.allowsSelection = false
            return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: identifier)
        }
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([0])
        dataSource.apply(snapshot)
    }
    
    private func configureCellRegistration() {
        cellRegistration = UICollectionView.CellRegistration<ChatCollectionViewCell, Chat> { (cell, indexPath, item) in
            cell.item = item
        }
    }
}

// MARK: - Send & Receive Chat

extension ChatViewController {
    
    @objc
    private func sendButtonTapped() {
        if let message = textView.text,
            message.isEmpty == false 
        {
            let userChat = Chat(sender: Sender.user, message: message)
            let loadingChat = Chat(sender: .loading, message: "\n")
            
            updateChats(withNew: [userChat, loadingChat])
            initTextView()
            sendMessage()
        }
    }
    
    private func sendMessage() {
        Task {
            do {
                let body = try JSONEncoder().encode(makeRequestModel())
                let request = try api.makeRequest(body: body)
                let response = try await networkManager.loadData(request: request)
                receiveMessage(with: response)
            } catch {
                showAlert(title: "오류", message: "\(MessageSendError.sendError.description) \(error)")
            }
        }
    }
    
    private func receiveMessage(with responseModel: ChatResponseModel) {
        guard let content = responseModel.choices.first?.message.content else { return }
        let assistantChat = Chat(sender: Sender.assistant, message: content)
        updateChats(withNew: [assistantChat])
    }
    
    private func updateChats(withNew chats: [Chat]) {
        var snapshot = dataSource.snapshot()
        
        if let lastChat = snapshot.itemIdentifiers(inSection: 0).last {
            if lastChat.sender == .loading {
                snapshot.deleteItems([lastChat])
            }
        }
        snapshot.appendItems(chats, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
        moveToLastChat()
    }
    
    private func makeRequestModel() -> ChatRequestModel {
        let snapshot = dataSource.snapshot()
        let chatMessage = snapshot.itemIdentifiers(inSection: 0).dropLast()
        var messages = [Message]()
        
        chatMessage.forEach { chat in
            let message = Message(
                role: chat.sender.description,
                content: chat.message,
                toolCalls: nil)
            messages.append(message)
        }
        
        let model = ChatRequestModel(
            model: "gpt-3.5-turbo-1106",
            messages: messages,
            stream: false,
            logprobs: false)
        
        return model
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    private func initTextView() {
        textView.text = nil
        textView.endEditing(true)
        textViewDidChange(textView)
    }
}

// MARK: - View 처리

extension ChatViewController {
    
    private func textFieldShouldReturn(_ textView: UITextView) -> Bool {
        if textView == self.textView {
            sendButtonTapped()
            textView.resignFirstResponder()
        }
        return true
    }
    
    private func moveToLastChat() {
        let lastIndex = IndexPath(item: dataSource.snapshot().numberOfItems - 1, section: 0)
        collectionView.scrollToItem(at: lastIndex, at: .bottom, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc
    func handleCellTap() {
        view.endEditing(true)
    }
}

// MARK: - UITextViewDelegate

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.constraints.forEach { constraint in
            guard textView.estimatedSizeHeight >= 150 else {
                if constraint.firstAttribute == .height {
                    constraint.constant = textView.estimatedSizeHeight
                }
                return
            }
        }
    }
}
