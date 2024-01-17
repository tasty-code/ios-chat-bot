//
//  ChatViewController.swift
//  ChatBot
//
//  Created by 김예준 on 1/9/24.
//

import UIKit

struct ChatMessage: Hashable {
    let sender: Sender
    let message: String
    let messageID = UUID()
}

final class ChatViewController: UIViewController {
    
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
    
    typealias ChatDataSource = UICollectionViewDiffableDataSource<Int, ChatMessage>
    typealias CellRegistration = UICollectionView.CellRegistration<ChatCollectionViewCell, ChatMessage>
    
    private var collectionView: UICollectionView!
    private var dataSource: ChatDataSource!
    private var cellRegistration: CellRegistration!
    private var messageStorage = [ChatMessage]()
    
    private let networkManager = NetworkManager()
    private let api = ChatAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayouts()
        setConstraints()
        configureDataSource()
        configureCellRegistration()
    }
    
    private func makeRequestModel(message: String) -> ChatRequestModel {
        let messages = [
            Message(
                role: "user",
                content: message,
                toolCalls: nil)]
        
        let model = ChatRequestModel(model: "gpt-3.5-turbo-1106",
                                    messages: messages,
                                    stream: false,
                                    logprobs: false)
        
        return model
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        collectionView.endEditing(true)
        ChatCollectionViewCell().endEditing(true)
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
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

extension ChatViewController {
    @objc
    private func sendButtonTapped() {
        if let message = textView.text, !message.isEmpty {
            let chatMessage = ChatMessage(sender: Sender.user, message: message)
            messageStorage.append(chatMessage)
            
            var snapshot = dataSource.snapshot()
            snapshot.deleteAllItems()
            snapshot.appendSections([0])
            snapshot.appendItems(messageStorage)
            dataSource.apply(snapshot, animatingDifferences: true)
            
            textView.text = nil
            textView.endEditing(true)
            textViewDidChange(textView)
            
            let requestModel = makeRequestModel(message: message)
            Task {
                do {
                    let body = try JSONEncoder().encode(requestModel)
                    let request = try api.makeRequest(body: body)
                    let responseModel = try await networkManager.loadData(request: request)
                    guard let msg = responseModel.choices.first?.message.content else {return}
                    
                    receiveMessage(message: msg)
                    
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func receiveMessage(message: String) {
        let chatResponse = ChatMessage(sender: Sender.assistant, message: message)
        messageStorage.append(chatResponse)
        
        var shot = NSDiffableDataSourceSnapshot<Int, ChatMessage>()
        shot.appendSections([0])
        shot.appendItems(messageStorage)
        dataSource.apply(shot, animatingDifferences: true)
    }
    
    private func configureDataSource() {
        dataSource = ChatDataSource(collectionView: collectionView) { (collectionView, indexPath, identifier) -> ChatCollectionViewCell? in
            collectionView.allowsSelection = false
            collectionView.isScrollEnabled = true
            return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func configureCellRegistration() {
        cellRegistration = UICollectionView.CellRegistration<ChatCollectionViewCell, ChatMessage> { (cell, indexPath, item) in
            cell.item = item
        }
    }
    
    private func textFieldShouldReturn(_ textView: UITextView) -> Bool {
        if textView == self.textView {
            sendButtonTapped()
            textView.resignFirstResponder()
        }
        return true
    }
}

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
