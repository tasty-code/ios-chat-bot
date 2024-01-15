//
//  ChatCollectionView.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/12.
//

import UIKit

final class ChatCollectionView: UICollectionView {
    
    private enum Section {
        case main
    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Message>?
    private var chatRecord: [Message] = []
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("ChatCollectionView error")
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ChatBallonCell, Message> { (cell, indexPath, itemIdentifier) in

            guard let text = itemIdentifier.content else { return }
            cell.setLabelText(text: text)
            cell.setNeedsUpdateConfiguration()
        }

        diffableDataSource = UICollectionViewDiffableDataSource<Section, Message>(collectionView: self, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        saveSnapshot()
    }

    func saveSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
        snapshot.appendSections([.main])
        snapshot.appendItems(chatRecord)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
