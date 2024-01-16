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
    
    var chats: [ChatBubble] = [
        ChatBubble(message: Message(role: "assistant", content: "ddd")),
        ChatBubble(message: Message(role: "user", content: "ddd")),
        ChatBubble(message: Message(role: "user", content: "ddddfdfgdfgdfgdfgdfgwert342523r523")),
        ChatBubble(message: Message(role: "user", content: "ddd")),
        ChatBubble(message: Message(role: "user", content: "ddwet2341235wefwedf3d")),
        ChatBubble(message: Message(role: "assistant", content: "ddd")),
        ChatBubble(message: Message(role: "assistant", content: "d23r5fgwedrftg234r5t234dd")),
        ChatBubble(message: Message(role: "assistant", content: "ddd")),
        ChatBubble(message: Message(role: "assistant", content: "d하워드바보cdd")),
        ChatBubble(message: Message(role: "user", content: "dd2342345wefg245t235t6235235623624623634634523d")),
        ChatBubble(message: Message(role: "assistant", content: "ddd")),
        ChatBubble(message: Message(role: "user", content: "ddd")),
        ChatBubble(message: Message(role: "user", content: "ddddfdfgdfgdfgdfgdfgwert342523r523")),
        ChatBubble(message: Message(role: "user", content: "ddd")),
        ChatBubble(message: Message(role: "user", content: "ddwet2341235wefwedf3d")),
        ChatBubble(message: Message(role: "assistant", content: "ddd")),
        ChatBubble(message: Message(role: "assistant", content: "d23r5fgwedrftg234r5t234dd")),
        ChatBubble(message: Message(role: "assistant", content: "ddd")),
        ChatBubble(message: Message(role: "assistant", content: "d하워드바보cdd")),
        ChatBubble(message: Message(role: "user", content: "dd2342345wefg245t235t6235235623624623634634523d")),
        ChatBubble(message: Message(role: "assistant", content: "ddd")),
        ChatBubble(message: Message(role: "user", content: "ddd")),
        ChatBubble(message: Message(role: "user", content: "ddddfdfgdfgdfgdfgdfgwert342523r523")),
        ChatBubble(message: Message(role: "user", content: "ddd")),
        ChatBubble(message: Message(role: "user", content: "ddwet2341235wefwedf3d")),
        ChatBubble(message: Message(role: "assistant", content: "ddd")),
        ChatBubble(message: Message(role: "assistant", content: "d23r5fgwedrftg234r5t234dd")),
        ChatBubble(message: Message(role: "assistant", content: "ddd")),
        ChatBubble(message: Message(role: "assistant", content: "d하워드바보cdd")),
        ChatBubble(message: Message(role: "user", content: "dd2342345wefg245t235t6rthrthyrtrtyrtyrtyrtyryrtyrty450y9i59034jkgh90ertik90ghik9034i90tk9340ktg9034tk9034kt903490i5t9034t9045io90yi4590yk9045y9045y9045ik9o0ti3490-i-9034i0-34ik-235235623624623634634523d")),
        
        
    ]
    
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
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 12
        return textView
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        try? chatService.sendMessage(text: "안녕") { result in
        //            switch result {
        //            case .success(let success):
        //                print("GPT: \(success.choices[0].message.content)")
        //            case .failure(let error):
        //                print(error)
        //            }
        //        }
        
        configurationUI()
        configurationCell()
        setUpSnapshot()
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
            mainStackView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -12),
                        
            textInputView.widthAnchor.constraint(equalTo: userInputStackView.widthAnchor, multiplier: 0.8),
            
            sendButton.widthAnchor.constraint(equalTo: userInputStackView.widthAnchor, multiplier: 0.1),

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
            case "assistant" :
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
}
