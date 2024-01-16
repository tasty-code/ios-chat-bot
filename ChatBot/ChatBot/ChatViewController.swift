//
//  ChatViewController.swift
//  ChatBot
//
//  Created by 김예준 on 1/9/24.
//

import UIKit

struct ChatMessage: Hashable {
    let sender: String
    let message: String
}

final class ChatViewController: UIViewController {
    private lazy var horizontalStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type your message here"
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.red.cgColor
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("전송", for: .normal)
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
    
    // TODO: 이걸 CoreData로 저장 예정
    private var messageStorage = [ChatMessage]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayouts()
        setConstraints()
        configureDataSource()
        configureCellRegistration()
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
        
        horizontalStackView.addArrangedSubviews([textField, sendButton])
        view.addSubview(horizontalStackView)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    private func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: textField.topAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 35),
            sendButton.heightAnchor.constraint(equalToConstant: 35),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            horizontalStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            horizontalStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60)
        ])
    }
    
    @objc
    private func sendButtonTapped() {
        if let message = textField.text, !message.isEmpty {
            let chatMessage = ChatMessage(sender: "ai", message: message)
            
            messageStorage.append(chatMessage)
            
            var snapshot = NSDiffableDataSourceSnapshot<Int, ChatMessage>()
            snapshot.appendSections([0])
            snapshot.appendItems(messageStorage)
            dataSource.apply(snapshot, animatingDifferences: false)
            textField.text = "" // Clear the text field after sending
        }
    }
}

extension ChatViewController {
    
    private func configureDataSource() {
        dataSource = ChatDataSource(collectionView: collectionView) { (collectionView, indexPath, identifier) -> ChatCollectionViewCell? in
            collectionView.allowsSelection = false
            return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: [indexPath.row], item: identifier)
        }
    }
    
    private func configureCellRegistration() {
        cellRegistration = UICollectionView.CellRegistration<ChatCollectionViewCell, ChatMessage> { (cell, indexPath, item) in
            cell.item = item
        }
    }
}
