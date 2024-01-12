//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

final class ViewController: UIViewController {

    private enum Section {
        case main
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

        return collectionView
    }()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Message>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
    private var chatRecord: [Message] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }

}

extension ViewController {
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false

        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ChatBallonCell, Message> { (cell, indexPath, itemIdentifier) in

            guard let text = itemIdentifier.content else { return }
            cell.setLabelText(text: text)
            cell.setNeedsUpdateConfiguration()
        }

        dataSource = UICollectionViewDiffableDataSource<Section, Message>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })

        snapshot.appendSections([.main])
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func saveSnapshot(data: Message) {
        snapshot.appendItems([data])
        chatRecord.append(data)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
