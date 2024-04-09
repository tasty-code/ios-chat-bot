//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/4/24.
//

import UIKit

import RxCocoa
import RxSwift

// 채팅 뷰 모델
final class ChatViewModel {
    private(set) var dataSource: UICollectionViewDiffableDataSource<Section, ChatMessage>?
    private(set) lazy var snapshotPublisher = PublishRelay<[ChatMessage]>()
    private(set) var service = ChatAPIService()
    private lazy var loadingMessage = createMessage(with: "loading", isUser: false)
    private(set) var networkResult: (any Disposable)?
}

// MARK: - Custom Methods
extension ChatViewModel {
    enum Section {
        case main
    }
    
    private func setUpSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatMessage>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func applySnapShot(with chatMessage: ChatMessage, strategy: SnapshotUpdateStrategy) {
        guard var snapshot = dataSource?.snapshot() else {
            return
        }
        
        strategy.apply(using: &snapshot, with: chatMessage, loadingMessage: loadingMessage)
        
        dataSource?.applySnapshotUsingReloadData(snapshot) { [weak self] in
            self?.snapshotPublisher.accept(snapshot.itemIdentifiers)
        }
    }
    
    private func requestAssistantChat(with chatMessage: ChatMessage) -> any Disposable {
        return service.createChat(
            systemContent: "Hello! How can I assist you today?",
            userContent: chatMessage.message
        ).subscribe(
            onSuccess: { [weak self] response in
                guard let message = response?.choices[0].message.content,
                      let chatMessage = self?.createMessage(with: message, isUser: false) else {
                    return
                }
                
                self?.applySnapShot(with: chatMessage, strategy: AssistantChatUpdateStrategy())
            }, onFailure: { [weak self] error in
                print(error)
                self?.removeLoadingIndicator()
                self?.toggleRefreshButton(for: chatMessage)
            }
        )
    }
    
    private func createMessage(with message: String, isUser: Bool) -> ChatMessage {
        return ChatMessage(
            id: UUID(),
            isUser: isUser,
            message: message,
            showRefreshButton: false
        )
    }
    
    private func toggleRefreshButton(for userChat: ChatMessage) {
        guard var snapshot = dataSource?.snapshot() else {
            return
        }
        
        var newChat = userChat
        newChat.toggleRefreshButton()
        
        snapshot.insertItems([newChat], beforeItem: userChat)
        snapshot.deleteItems([userChat])
        
        dataSource?.applySnapshotUsingReloadData(snapshot) { [weak self] in
            self?.snapshotPublisher.accept(snapshot.itemIdentifiers)
        }
    }
}

// MARK: - Public Methods
extension ChatViewModel {
    func setDataSource(delegate: ChatCollectionViewCellDelegate, collectionView: UICollectionView) {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            
            if itemIdentifier.id == self?.loadingMessage.id {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatLoadingCollectionViewCell.className, for: indexPath) as? ChatLoadingCollectionViewCell else {
                    return ChatLoadingCollectionViewCell()
                }
                return cell
                
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.className, for: indexPath) as? ChatCollectionViewCell else {
                    return ChatCollectionViewCell()
                }
                
                cell.delegate = delegate
                cell.text(itemIdentifier.message, isUser: itemIdentifier.isUser)
                if itemIdentifier.showRefreshButton {
                    cell.showRefreshButton()
                }
                return cell
            }
        }
        
        setUpSnapshot()
    }
    
    func updateUserChat(with message: String) {
        let chatMessage = createMessage(with: message, isUser: true)
        applySnapShot(with: chatMessage, strategy: UserChatUpdateStrategy())
        networkResult = requestAssistantChat(with: chatMessage)
    }
    
    func removeLastChat() {
        guard var snapshot = dataSource?.snapshot(),
              let last = snapshot.itemIdentifiers.last else {
            return
        }
        
        snapshot.deleteItems([last])
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
    
    func removeLoadingIndicator() {
        guard var snapshot = dataSource?.snapshot() else {
            return
        }
        snapshot.deleteItems([loadingMessage])
        
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
}
