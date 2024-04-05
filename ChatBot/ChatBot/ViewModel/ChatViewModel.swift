//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/4/24.
//

import UIKit

import RxCocoa

// 채팅 뷰 모델
final class ChatViewModel {
    private var dataSource: UICollectionViewDiffableDataSource<Section, ChatMessage>?
    private(set) lazy var snapshotPublisher = PublishRelay<[ChatMessage]>()
    private(set) var service = ChatAPIService()
    private let loadingMessage = ChatMessage(id: UUID(), isUser: false, message: "loading")
}

// MARK: - Custom Methods
extension ChatViewModel {
    enum Section {
        case main
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
    
    private func removeLoadingIndicator() {
        guard var snapshot = dataSource?.snapshot() else {
            return
        }
        snapshot.deleteItems([loadingMessage])
        
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
}

// MARK: - Public Methods
extension ChatViewModel {
    func setDataSource(collectionView: UICollectionView) {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            
            if itemIdentifier.id == self?.loadingMessage.id {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatLoadingCollectionViewCell.className, for: indexPath) as? ChatLoadingCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return cell
                
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.className, for: indexPath) as? ChatCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                cell.text(itemIdentifier.message, isUser: itemIdentifier.isUser)
                return cell
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatMessage>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func updateMessage(with message: String) {
        let chatMessage = ChatMessage(id: UUID(), isUser: true, message: message)
        applySnapShot(with: chatMessage, strategy: LoadingIndicatorUpdateStrategy())
        
        _ = service.createChat(systemContent: "Hello! How can I assist you today?",
                                userContent: message)
            .subscribe(onSuccess: { [weak self] result in
                
                guard let message = result?.choices[0].message.content else {
                    return
                }
                
                let chatMessage = ChatMessage(id: UUID(), isUser: false, message: message)
                self?.applySnapShot(with: chatMessage, strategy: MessageUpdateStrategy())
            }, onFailure: { [weak self] error in
                print(error)
                self?.removeLoadingIndicator()
            })
    }
}
