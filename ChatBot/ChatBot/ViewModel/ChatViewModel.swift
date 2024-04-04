//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/4/24.
//

import UIKit

import RxSwift

final class ChatViewModel {
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>?
    private(set) var service = ChatAPIService()
    
    private var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
}

extension ChatViewModel {
    func setDataSource(collectionView: UICollectionView) {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.className, for: indexPath) as? ChatCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.text(itemIdentifier, isUser: false)
            return cell
        }
    }
    
    func updateMessage(with message: String) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(["test1", "test2", "test3", "test4"])
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        _ = self.service.createChat(systemContent: "Hello! How can I assist you today?",
                                userContent: message)
            .subscribe(onSuccess: { result in
                guard let message = result?.choices[0].message.content else {
                    return
                }
                self.snapshot.appendSections([.main])
                self.snapshot.appendItems([message])
                self.dataSource?.apply(self.snapshot)
            }, onFailure: { error in
                print(error)
            })
    }
}

extension ChatViewModel {
    enum Section {
        case main
    }
}
