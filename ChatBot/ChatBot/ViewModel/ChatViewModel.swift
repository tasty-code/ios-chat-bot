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
    enum Section {
        case main
    }
    
    private(set) var dataSource: UICollectionViewDiffableDataSource<Section, ChatMessage>?
    private(set) lazy var snapshotPublisher = PublishRelay<[ChatMessage]>()
    private(set) var service = ChatAPIService()
    private lazy var loadingMessage = createMessage(with: "loading", isUser: false)
    private var snapshot: NSDiffableDataSourceSnapshot<Section, ChatMessage> {
        guard let snapshot = dataSource?.snapshot() else {
            return NSDiffableDataSourceSnapshot<Section, ChatMessage>()
        }
        return snapshot
    }
}

// MARK: - Custom Methods
extension ChatViewModel {
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
                self?.applySnapShot(with: chatMessage, strategy: RefreshButtonToggleStrategy())
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
    
    private func removeLoadingIndicator() {
        let emptyMessage = ChatMessage(
            id: UUID(),
            isUser: false,
            message: "",
            showRefreshButton: false
        )
        applySnapShot(with: emptyMessage, strategy: LoadingIndicatorRemoveStrategy())
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
                
                let view = itemIdentifier.isUser ? UserChatBubbleView() : AssistantChatBubbleView()
                
                cell.setChatBubbleView(view)
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
        _ = requestAssistantChat(with: chatMessage)
    }
    
    func removeLastChat() {
        let emptyMessage = ChatMessage(
            id: UUID(),
            isUser: false,
            message: "",
            showRefreshButton: false
        )
        applySnapShot(with: emptyMessage, strategy: LastChatRemoveStrategy())
    }
}

// MARK: - Snapshots
extension ChatViewModel {
    private func setUpSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatMessage>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func applySnapShot(with chatMessage: ChatMessage, strategy: SnapshotUpdateStrategy) {
        var snapshot = snapshot
        strategy.apply(using: &snapshot, with: chatMessage, loadingMessage: loadingMessage)
        
        dataSource?.apply(snapshot) { [weak self] in
            guard let items = self?.snapshot.itemIdentifiers else {
                return
            }
            self?.snapshotPublisher.accept(items)
        }
    }
}
