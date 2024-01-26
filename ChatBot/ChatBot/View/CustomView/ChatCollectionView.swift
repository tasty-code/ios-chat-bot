//
//  ChatCollectionView.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/25.
//

import UIKit

final class ChatCollectionView: UICollectionView {
    private var diffableDataSource: DiffableDataSource?
    
    init(frame: CGRect) {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.allowsSelection = false
        
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - typealias

extension ChatCollectionView {
    private typealias LeftCellRegistration = UICollectionView.CellRegistration<LeftBalloonCell, Message>
    private typealias RightCellRegistration = UICollectionView.CellRegistration<RightBalloonCell, Message>
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Message>
}


// MARK: - DiffableDataSource

extension ChatCollectionView {
    private func configureDataSource() {
        let leftCellRegistration = LeftCellRegistration { (cell, indexPath, itemIdentifier) in
            
            cell.setLabelText(text: itemIdentifier.content!)
            cell.makeBalloon()
        }
        
        let rightCellRegistration = RightCellRegistration { (cell, indexPath, itemIdentifier) in

            cell.setLabelText(text: itemIdentifier.content!)
            cell.makeBalloon()
        }
        
        diffableDataSource = DiffableDataSource(collectionView: self, cellProvider: { collectionView, indexPath, message in
            if message.role == .user {
                return collectionView.dequeueConfiguredReusableCell(using: rightCellRegistration, for: indexPath, item: message)
            }
            return collectionView.dequeueConfiguredReusableCell(using: leftCellRegistration, for: indexPath, item: message)
        })
        
        saveSnapshot(chatRecord: [])
    }

    func saveSnapshot(chatRecord: [Message]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
        snapshot.appendSections([.main])
        snapshot.appendItems(chatRecord, toSection: .main)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

