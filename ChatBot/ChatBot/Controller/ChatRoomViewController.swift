//
//  ChatRoomViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class ChatRoomViewController : UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, ChatBubble>
    
    enum Section {
        case main
    }
    
    private var chatManager = ChatManager()
    private let chatService = ChatService()
    private var dataSource: DataSource?
    
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private var userInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
    
    private var textInputView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.cornerRadius = 12
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = #colorLiteral(red: 0.7890922427, green: 0.9981873631, blue: 0.9562725425, alpha: 1)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.addTarget(self, action: #selector(tappedSendButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationUI()
        configurationCell()
        setUpSnapshot()
        self.textInputView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateCollectionView), name: Notification.Name("ChatsUpdatedNotification"), object: nil)
    }
    
    private func configurationUI() {
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(userInputStackView)
        
        userInputStackView.addArrangedSubview(textInputView)
        userInputStackView.addArrangedSubview(sendButton)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        userInputStackView.translatesAutoresizingMaskIntoConstraints = false
        textInputView.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -12),
            textInputView.widthAnchor.constraint(equalTo: userInputStackView.widthAnchor, multiplier: 0.8),
            textInputView.heightAnchor.constraint(equalToConstant: textInputView.estimatedHeight),
            sendButton.widthAnchor.constraint(equalTo: userInputStackView.widthAnchor, multiplier: 0.15),
        ])
    }
    
    @objc func tappedSendButton() {
        textInputView.resignFirstResponder()
        
        guard let question = textInputView.text, question != "" else { return }
        chatManager.appendChat(question: question)
        sendButton.isEnabled = false
        
        let chats = chatManager.getChats()
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            try? self.chatService.sendChats(chats: chats) { result in
                switch result {
                case .success(let success):
                    let answer = success.choices[0].message.content
                    self.chatManager.responseChat(answer: answer)
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.sendButton.isEnabled = true
                    }
                case .failure:
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let alert = UIAlertController(title: "전송 실패", message: "통신 실패 네트워크 상태를 확인해주세요.", preferredStyle: .alert)
                            
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                            self.chatManager.removeLastChat()
                            self.setUpSnapshot()
                        }))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
        
        textInputView.text = nil
        textInputView.insertText("")
    }
    
    @objc private func updateCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setUpSnapshot()
            self.moveScroll()
        }
    }
}

// MARK: - UITextViewDelegate
extension ChatRoomViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView.contentSize.height <= view.frame.height * 0.1 else {
            textView.isScrollEnabled = true
            return
        }
        
        textView.isScrollEnabled = false
        
        textView.constraints.forEach { (constraint) in
            guard constraint.firstAttribute != .height else {
                constraint.constant = textView.estimatedHeight
                return
            }
        }
    }
}

// MARK: - CollectionView
extension ChatRoomViewController {
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configurationCell() {
        let chatBubbleRegistration = UICollectionView.CellRegistration<BubbleCell, ChatBubble> { cell, indexPath, itemIdentifier in
            cell.setBubbleCell(message: itemIdentifier.message)
        }
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell in
            return collectionView.dequeueConfiguredReusableCell(using: chatBubbleRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func setUpSnapshot() {
        let chats = chatManager.getChats()
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatBubble>()
        snapshot.appendSections([.main])
        snapshot.appendItems(chats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func moveScroll() {
        collectionView.scrollToItem(at: IndexPath(row: chatManager.getChats().endIndex - 1, section: .zero), at: .bottom, animated: true)
    }
    
}
