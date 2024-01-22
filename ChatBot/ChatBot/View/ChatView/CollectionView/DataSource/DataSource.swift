//
//  DataSource.swift
//  ChatBot
//
//  Created by 김경록 on 1/17/24.
//
import UIKit

enum Section {
    case main
}

final class ChatCollectionViewDataSource: UICollectionViewDiffableDataSource<Section, Message> {
    
    init(collectionView: UICollectionView) {
        let cellRegistration = UICollectionView.CellRegistration<ChatCollectionViewCell, Message> { (cell, indexPath, item) in
            cell.configureBubbles(identifier: item)
        }
        
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            return cell
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Message>()
        snapShot.appendSections([.main])
        self.apply(snapShot, animatingDifferences: false)
    }
    
    // MARK: - todo: chatUIItem 적절히 처리하기

    func updateSnapshot(items: [Message], isFetched: Bool) {
        var snapShot = self.snapshot()
        
        if isFetched {
            snapShot.deleteItems([ViewController.chatUIItem])
            self.apply(snapShot, animatingDifferences: true)
        }
        
        snapShot.appendItems(items)
        self.apply(snapShot, animatingDifferences: true)
    }
}
