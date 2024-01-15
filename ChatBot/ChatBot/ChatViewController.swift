//
//  ChatViewController.swift
//  ChatBot
//
//  Created by 김예준 on 1/9/24.
//

import UIKit

final class ChatViewController: UIViewController {
        
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type your message here"
        textField.borderStyle = .roundedRect
        textField.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 16.0))
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.backgroundColor = .systemMint
        
        return button
    }()
    
    typealias ChatDataSource = UICollectionViewDiffableDataSource<Int, ChatMessage>
    
    private var collectionView: UICollectionView!
    
    private var dataSource: ChatDataSource!
    
    // TODO: 이걸 CoreData로 저장
    private var messageStorage = [ChatMessage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHirearchy()
        configureDataSource()
        
    }
}

// MARK: - Configure Layout

extension ChatViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureHirearchy() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(textField)
        view.addSubview(sendButton)
        
        setConstraints()
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    private func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: textField.topAnchor),
            
            textField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
            textField.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -100),
            
            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            sendButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
        ])
    }
    
    struct ChatMessage: Hashable {
        let sender: String
        let message: String
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
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ChatMessage> { (cell, indexPath, item) in
            var contentConfiguration = UIListContentConfiguration.cell()
            let chatMessage = self.messageStorage[indexPath.row]
            contentConfiguration.text = "\(chatMessage.message)"
            
            var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
//            backgroundConfiguration.customView = self.makeChatBalloonView(cell: cell, role: chatMessage.sender, message: chatMessage.message)
            let bubbleView = BubbleView(width: 100, height: 50)
//            bubbleView.sizeToFit()
            backgroundConfiguration.customView = bubbleView
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = backgroundConfiguration
            cell.backgroundView?.sizeToFit()
        }
        
        dataSource = ChatDataSource(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: identifier)
        }
    }
    
    private func makeChatBalloonView(cell: UICollectionViewListCell, role: String, message: String) -> UIView {
        let chatBalloon: UIView = {
            
            let messageHeight = heightForMessage(message: message, maxWidth: cell.bounds.width - 16) + 20 // Adjust the padding as needed
            
            // Set the initial height of the chat balloon
            let initialHeight: CGFloat = cell.bounds.height // Set your desired initial height
            let height = max(messageHeight, initialHeight)
            print("height: \(initialHeight) message: \(message)")
            
            let view = UIView(frame: CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.width, height: height))
            
            var maskPath: UIBezierPath
            switch role {
            case "mine":
                view.backgroundColor = .systemBlue
                
                // Set corner radius for all corners except the top right corner
                maskPath = UIBezierPath(
                    roundedRect: view.bounds,
                    byRoundingCorners: [.topLeft, .bottomLeft, .bottomRight],
                    cornerRadii: CGSize(width: 10, height: 10)
                )
            case "ai":
                view.backgroundColor = .systemGray
                
                // Set corner radius for all corners except the top right corner
                maskPath = UIBezierPath(
                    roundedRect: view.bounds,
                    byRoundingCorners: [.topRight, .bottomLeft, .bottomRight],
                    cornerRadii: CGSize(width: 10, height: 10)
                )
            default:
                print("enum으로 바꾸기")
                maskPath = UIBezierPath()
            }
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            view.layer.mask = maskLayer
            return view
        }()
        
        return chatBalloon
    }
    
    
    // Function to calculate the height of the message based on the width constraint
    private func heightForMessage(message: String, maxWidth: CGFloat) -> CGFloat {
        let font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 16.0))
        let size = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: font]
        
        let boundingRect = message.boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return ceil(boundingRect.height)
    }
    
}
