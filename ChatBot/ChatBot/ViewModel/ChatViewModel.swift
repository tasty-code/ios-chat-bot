//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/4/24.
//

import UIKit

import RxSwift

final class ChatViewModel {
    private var dataSource: UICollectionViewDiffableDataSource<Section, ChatMessage>?
    private(set) var service = ChatAPIService()
    
    private var snapshot = NSDiffableDataSourceSnapshot<Section, ChatMessage>()
}

extension ChatViewModel {
    func setDataSource(collectionView: UICollectionView) {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.className, for: indexPath) as? ChatCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.text(itemIdentifier.message, isUser: itemIdentifier.isUser)
            return cell
        }
    }
    
    func updateMessage(with message: String) {
        let chatMessage = ChatMessage(id: UUID(), isUser: true, message: message)
        createSnapShot(with: chatMessage)
        
        _ = service.createChat(systemContent: "Hello! How can I assist you today?",
                                userContent: message)
            .subscribe(onSuccess: { [weak self] result in
                
                guard let message = result?.choices[0].message.content else {
                    return
                }
                
                let chatMessage = ChatMessage(id: UUID(), isUser: false, message: message)
                self?.createSnapShot(with: chatMessage)
            }, onFailure: { error in
                print(error)
            })
    }
}

extension ChatViewModel {
    enum Section {
        case main
    }
    
    private func createSnapShot(with chatMessage: ChatMessage) {
        let isSection = snapshot.sectionIdentifiers.contains(.main)
        
        switch isSection {
        case true:
            guard let last = snapshot.itemIdentifiers.last else {
                return
            }
            snapshot.insertItems([chatMessage], afterItem: last)
            dataSource?.applySnapshotUsingReloadData(snapshot)
            
        case false:
            snapshot.appendSections([.main])
            snapshot.appendItems([chatMessage])
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
}
