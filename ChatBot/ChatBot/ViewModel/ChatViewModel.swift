//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/4/24.
//

import UIKit

import RxSwift

// 채팅 뷰 모델
final class ChatViewModel {
    private var dataSource: UICollectionViewDiffableDataSource<Section, ChatMessage>?
    private(set) var service = ChatAPIService()
}

// MARK: - Custom Methods
extension ChatViewModel {
    enum Section {
        case main
    }
    
    private func applySnapShot(with chatMessage: ChatMessage) {
        guard var snapshot = dataSource?.snapshot() else {
            return
        }
        
        if let last = snapshot.itemIdentifiers.last {
            snapshot.insertItems([chatMessage], afterItem: last)
        } else {
            snapshot.appendItems([chatMessage])
        }
        
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
}

// MARK: - Public Methods
extension ChatViewModel {
    func setDataSource(collectionView: UICollectionView) {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.className, for: indexPath) as? ChatCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.text(itemIdentifier.message, isUser: itemIdentifier.isUser)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatMessage>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func updateMessage(with message: String) {
        let chatMessage = ChatMessage(id: UUID(), isUser: true, message: message)
        applySnapShot(with: chatMessage)
        
        _ = service.createChat(systemContent: "Hello! How can I assist you today?",
                                userContent: message)
            .subscribe(onSuccess: { [weak self] result in
                
                guard let message = result?.choices[0].message.content else {
                    return
                }
                
                let chatMessage = ChatMessage(id: UUID(), isUser: false, message: message)
                self?.applySnapShot(with: chatMessage)
            }, onFailure: { error in
                print(error)
            })
    }
}
