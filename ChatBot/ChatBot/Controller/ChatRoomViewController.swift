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
    
    private let chatService = ChatService()
    private var dataSource: DataSource?
    
    var chats: [ChatBubble] = []
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        return collectionView
    }()
    
    lazy var userInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
    
    lazy var textInputView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.cornerRadius = 12
        return textView
    }()
    
    lazy var sendButton: UIButton = {
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
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configurationUI() {
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(userInputStackView)
        
        userInputStackView.addArrangedSubview(textInputView)
        userInputStackView.addArrangedSubview(sendButton)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func configurationCell() {
        let userChatBubbleRegistration = UICollectionView.CellRegistration<BubbleCell, ChatBubble> { cell, indexPath, itemIdentifier in
            cell.setBubbleCell(message: itemIdentifier.message)
        }
        let assistantChatBubbleRegistration = UICollectionView.CellRegistration<BubbleCell, ChatBubble> { cell, indexPath, itemIdentifier in
            cell.setBubbleCell(message: itemIdentifier.message)
        }
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell in
            switch identifier.message.role {
            case "user":
                return collectionView.dequeueConfiguredReusableCell(using: userChatBubbleRegistration, for: indexPath, item: identifier)
            case "assistant":
                return collectionView.dequeueConfiguredReusableCell(using: assistantChatBubbleRegistration, for: indexPath, item: identifier)
            default :
                return collectionView.dequeueConfiguredReusableCell(using: assistantChatBubbleRegistration, for: indexPath, item: identifier)
            }
        }
    }
    
    private func setUpSnapshot() {
        let chats = self.chats
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatBubble>()
        snapshot.appendSections([.main])
        snapshot.appendItems(chats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func moveScroll() {
        collectionView.scrollToItem(at: IndexPath(row: chats.endIndex - 1, section: .zero), at: .bottom, animated: true)
    }
    
    @objc func tappedSendButton() {
        sendButton.isEnabled = false
        textInputView.resignFirstResponder()
        guard let question = textInputView.text else { return }
        
        chats.append(ChatBubble(message: Message(role: "user", content: question)))
        chats.append(ChatBubble(message: Message(role: "assistant", content: "")))
        setUpSnapshot()
        moveScroll()
        
        DispatchQueue.global().async { [self] in
            try? self.chatService.sendMessage(text: question) { result in
                switch result {
                case .success(let success):
                    let answer = success.choices[0].message.content
                    self.chats[self.chats.count - 1] = ChatBubble(message: Message(role: "assistant", content: answer))
                    
                    DispatchQueue.main.async {
                        self.setUpSnapshot()
                        self.moveScroll()
                        self.sendButton.isEnabled = true
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        textInputView.text = nil
        textInputView.insertText("")
    }
}

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

extension UITextView {
    var estimatedHeight: CGFloat {
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedSize = self.sizeThatFits(size)
        return estimatedSize.height
    }
}
